import docker
import copy
import sys
import os
import subprocess
import tempfile
import bugzoo

from typing import List, Iterator, Dict
from timeit import default_timer as timer

from bugzoo.core import Language
from bugzoo.cmd import ExecResponse, PendingExecResponse
from bugzoo.testing import TestOutcome, TestCase
from bugzoo.patch import Patch
from bugzoo.tool import Tool
from bugzoo.coverage.base import ProjectLineCoverage, \
                                 ProjectCoverageMap
from bugzoo.coverage.spectra import Spectra


class CompilationOutcome(object):
    def __init__(self, command_outcome: ExecResponse) -> None:
        self.__command_outcome = command_outcome

    @property
    def successful(self):
        return self.__command_outcome.code == 0


class Container(object):
    """
    Containers provide ephemeral, mutable instances of registered bugs,
    and are used to conduct studies of software bugs. Behind the scenes,
    containers are implemented as `Docker containers <https://docker.com>`_.
    """
    def __init__(self,
                 bug: str = 'bugzoo.bug.Bug',
                 tools : List[Tool] = [],
                 volumes : Dict[str, str] = {},
                 network_mode : str = 'bridge',
                 ports={},
                 interactive=False) -> None:
        """
        Constructs a container for a given bug.
        """
        self.__bug = bug
        self.__tools = tools
        self.__tool_containers = [t.provision() for t in tools]
        tool_container_ids = [c.id for c in self.__tool_containers]

        # prepare the environment for the container
        env = [(k, v) for t in tools for (k, v) in t.environment.items()]
        env = ["{}=\"{}\"".format(k, v) for (k, v) in env]
        env = "\n".join(env)
        self.__env_file = tempfile.NamedTemporaryFile(mode='w')
        self.__env_file.write(env)
        self.__env_file.flush()

        # we don't want to accidentally disturb the dictionary that was passed
        volumes = copy.deepcopy(volumes)

        # mount the environment file
        volumes[self.__env_file.name] = \
            {'bind': '/.environment', 'mode': 'rw'}

        # construct a Docker container for this bug
        client = docker.from_env()
        self.__container = \
            client.containers.create(bug.image,
                                     '/bin/bash -v -c "source /.environment && /bin/bash"',
                                     volumes=volumes,
                                     volumes_from=tool_container_ids,
                                     ports=ports,
                                     network_mode=network_mode,
                                     stdin_open=True,
                                     tty=interactive,
                                     detach=True)
        self.__container.start()

    @property
    def id(self) -> str:
        """
        A unique identifier for this container.
        """
        assert self.alive
        return self.__container.id


    @property
    def tools(self) -> Iterator[Tool]:
        """
        A list of tools that are mounted inside this container.
        """
        for tool in self.__tools:
            yield tool


    @property
    def bug(self) -> 'bugzoo.bug.Bug':
        """
        The bug that was used to provision this container.
        """
        return self.__bug


    @property
    def container(self):
        """
        The Docker container underlying this object, or :code:`None`, if the
        container is no longer running.
        """
        return self.__container


    @property
    def alive(self) -> bool:
        """
        Indicates whether or not the container is still running.
        """
        return self.__container is not None


    def interact(self) -> None:
        """
        Connects to the PTY (pseudo-TTY) for this container.
        Blocks until the user exits the PTY. Does not handle destruction of
        the container; user should call `destroy` once finished with the
        container.
        """
        subprocess.call(['docker', 'attach', self.__container.id])


    def destroy(self) -> None:
        """
        Deallocates all resources associated with this container. If this
        container has already been destroyed, this method quietly returns
        (i.e., no errors are thrown).
        """
        if self.__container:
            self.__container.remove(force=True)

        # destroy tool containers
        for c in self.__tool_containers:
            c.remove(force=True)
        self.__tool_containers = []

        # destroy env file
        if self.__env_file:
            self.__env_file.close()
            self.__env_file = None


    def mount_file(self, src: str, dest: str, mode: str) -> None:
        """
        Dynamically mounts a given file (or directory) inside this container.

        https://jpetazzo.github.io/2015/01/13/docker-mount-dynamic-volumes/
        """
        assert isinstance(src, str)
        assert isinstance(dest, str)
        assert os.path.exists(src)
        assert mode in ['ro', 'rw']


    def reset(self) -> None:
        """
        Resets the state of this container.
        """
        raise NotImplementedError


    def apply_patch(self, patch: Patch) -> bool:
        """
        Attempts to apply a given patch to the source code. All patch
        applications are guaranteed to be atomic; if the patch fails to
        apply, no changes will be made to the relevant source code files.

        Returns true if the patch application was successful, and false if
        the attempt was unsuccessful.
        """
        pass


    def copy_to(self, source_fn: str, dest_fn: str) -> None:
        """
        Copies a given file from the host machine to a specified location
        inside this container.
        """
        ctr_id = self.container.id
        cmd = "docker cp '{}' '{}:{}'".format(source_fn, ctr_id, dest_fn)
        subprocess.check_output(cmd, shell=True)


    def command(self,
                cmd: str,
                context: str = '/',
                stdout: bool = True,
                stderr: bool = False,
                block: bool = True):
        """

        Returns a tuple containing the exit code, execution duration, and
        output, respectively.
        """
        cmd = '/bin/bash -c "cd {} && {}"'.format(context, cmd)

        # based on: https://github.com/roidelapluie/docker-py/commit/ead9ffa34193281967de8cc0d6e1c0dcbf50eda5
        client = docker.from_env()
        response = client.api.exec_create(self.__container.id, cmd, stdout=stdout, stderr=stderr)

        # blocking mode
        if block:
            start_time = timer()
            out = client.api.exec_start(response['Id'], stream=False)
            end_time = timer()
            duration = end_time - start_time
            code = client.api.exec_inspect(response['Id'])['ExitCode']
            return ExecResponse(code, duration, out)

        # non-blocking mode
        else:
            out = client.api.exec_start(response['Id'], stream=True)
            out = out.decode(sys.stdout.encoding)
            return PendingExecResponse(response, out)

    def coverage(self,
                 tests: List[TestCase] = None
                 ) -> ProjectCoverageMap:
        """
        Computes line coverage information for an optionally provided list of
        tests. If no list of tests is provided, then coverage will be computed
        for all tests within the test suite associated with the program inside
        this container.
        """
        assert self.alive
        assert tests != []

        if tests is None:
            tests = self.bug.tests

        # fetch the extractor for this language
        # TODO: assumes a single language
        language = self.bug.languages[0]
        extractor = language.coverage_extractor
        return extractor.coverage(self, tests)

    def compile(self,
                options: Dict[str, str] = None,
                verbose: bool = True
                ) -> CompilationOutcome:
        """
        Attempts to compile the program inside this container.

        Params:
            options: An optional dictionary of keyword parameters that are
                supplied to the compilation command. If a parameter within
                the command template is not supplied with a value, then an
                empty string will be used instead.
            verbose: Specifies whether to print the stdout and stderr produced
                by the compilation command to the stdout. If `True`, then the
                stdout and stderr will be printed.

        Returns:
            A summary of the outcome of the compilation attempt.
        """
        # TODO: hardcoded!
        cmd = "make clean && make -j8 CFLAGS='-fprofile-arcs -ftest-coverage -fPIC'"
        # TODO: use virtual compiler
        # cmd = self.bug.compilation_instructions.command
        cmd_outcome = self.command(cmd,
                                   context=self.bug.compilation_instructions.context,
                                   stderr=True)
        return CompilationOutcome(cmd_outcome)


    def execute(self, test: TestCase) -> TestOutcome:
        """
        Executes a given test inside this container and returns the outcome of
        the execution.
        """
        (cmd, ctx) = self.bug.harness.command(test)
        response = self.command(cmd, ctx, stderr=True)
        passed = response.code == 0
        return TestOutcome(response, passed)