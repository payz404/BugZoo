#!/usr/bin/perl -w
use strict;

# there are 572 tests in this list
my @tests = (
    "cachegrind/tests/chdir.vgtest",
    "cachegrind/tests/clreq.vgtest",
    "cachegrind/tests/dlclose.vgtest",
    "cachegrind/tests/notpower2.vgtest",
    "cachegrind/tests/wrap5.vgtest",
    "cachegrind/tests/x86/fpu-28-108.vgtest",
    "callgrind/tests/clreq.vgtest",
    "callgrind/tests/notpower2-hwpref.vgtest",
    "callgrind/tests/notpower2-use.vgtest",
    "callgrind/tests/notpower2.vgtest",
    "callgrind/tests/notpower2-wb.vgtest",
    "callgrind/tests/simwork1.vgtest",
    "callgrind/tests/simwork2.vgtest",
    "callgrind/tests/simwork3.vgtest",
    "callgrind/tests/simwork-both.vgtest",
    "callgrind/tests/simwork-branch.vgtest",
    "callgrind/tests/simwork-cache.vgtest",
    "callgrind/tests/threads-use.vgtest",
    "callgrind/tests/threads.vgtest",
    "drd/tests/annotate_barrier.vgtest",
    "drd/tests/annotate_barrier_xml.vgtest",
    "drd/tests/annotate_hbefore.vgtest",
    "drd/tests/annotate_hb_err.vgtest",
    "drd/tests/annotate_hb_race.vgtest",
    "drd/tests/annotate_ignore_read.vgtest",
    "drd/tests/annotate_ignore_rw2.vgtest",
    "drd/tests/annotate_ignore_rw.vgtest",
    "drd/tests/annotate_ignore_write2.vgtest",
    "drd/tests/annotate_ignore_write.vgtest",
    "drd/tests/annotate_order_1.vgtest",
    "drd/tests/annotate_order_2.vgtest",
    "drd/tests/annotate_order_3.vgtest",
    "drd/tests/annotate_publish_hg.vgtest",
    "drd/tests/annotate_rwlock_hg.vgtest",
    "drd/tests/annotate_rwlock.vgtest",
    "drd/tests/annotate_smart_pointer2.vgtest",
    "drd/tests/annotate_smart_pointer.vgtest",
    "drd/tests/annotate_spinlock.vgtest",
    "drd/tests/annotate_static.vgtest",
    "drd/tests/annotate_trace_memory.vgtest",
    "drd/tests/annotate_trace_memory_xml.vgtest",
    "drd/tests/atomic_var.vgtest",
    "drd/tests/bar_bad.vgtest",
    "drd/tests/bar_bad_xml.vgtest",
    "drd/tests/bar_trivial.vgtest",
    "drd/tests/boost_thread.vgtest",
    "drd/tests/bug-235681.vgtest",
    "drd/tests/circular_buffer.vgtest",
    "drd/tests/custom_alloc_fiw.vgtest",
    "drd/tests/custom_alloc.vgtest",
    "drd/tests/fp_race2.vgtest",
    "drd/tests/fp_race.vgtest",
    "drd/tests/fp_race_xml.vgtest",
    "drd/tests/free_is_write2.vgtest",
    "drd/tests/free_is_write.vgtest",
    "drd/tests/hg01_all_ok.vgtest",
    "drd/tests/hg02_deadlock.vgtest",
    "drd/tests/hg03_inherit.vgtest",
    "drd/tests/hg04_race.vgtest",
    "drd/tests/hg05_race2.vgtest",
    "drd/tests/hg06_readshared.vgtest",
    "drd/tests/hold_lock_1.vgtest",
    "drd/tests/hold_lock_2.vgtest",
    "drd/tests/linuxthreads_det.vgtest",
    "drd/tests/matinv.vgtest",
    "drd/tests/memory_allocation.vgtest",
    "drd/tests/monitor_example.vgtest",
    "drd/tests/new_delete.vgtest",
    "drd/tests/omp_matinv_racy.vgtest",
    "drd/tests/omp_matinv.vgtest",
    "drd/tests/omp_prime_racy.vgtest",
    "drd/tests/omp_printf.vgtest",
    "drd/tests/pth_barrier2.vgtest",
    "drd/tests/pth_barrier3.vgtest",
    "drd/tests/pth_barrier_race.vgtest",
    "drd/tests/pth_barrier_reinit.vgtest",
    "drd/tests/pth_barrier_thr_cr.vgtest",
    "drd/tests/pth_barrier.vgtest",
    "drd/tests/pth_broadcast.vgtest",
    "drd/tests/pth_cancel_locked.vgtest",
    "drd/tests/pth_cleanup_handler.vgtest",
    "drd/tests/pth_cond_race2.vgtest",
    "drd/tests/pth_cond_race3.vgtest",
    "drd/tests/pth_cond_race.vgtest",
    "drd/tests/pth_create_chain.vgtest",
    "drd/tests/pth_create_glibc_2_0.vgtest",
    "drd/tests/pth_detached2.vgtest",
    "drd/tests/pth_detached3.vgtest",
    "drd/tests/pth_detached.vgtest",
    "drd/tests/pth_inconsistent_cond_wait.vgtest",
    "drd/tests/pth_mutex_reinit.vgtest",
    "drd/tests/pth_once.vgtest",
    "drd/tests/pth_process_shared_mutex.vgtest",
    "drd/tests/pth_spinlock.vgtest",
    "drd/tests/pth_uninitialized_cond.vgtest",
    "drd/tests/read_and_free_race.vgtest",
    "drd/tests/recursive_mutex.vgtest",
    "drd/tests/rwlock_race.vgtest",
    "drd/tests/rwlock_test.vgtest",
    "drd/tests/rwlock_type_checking.vgtest",
    "drd/tests/sem_as_mutex2.vgtest",
    "drd/tests/sem_as_mutex3.vgtest",
    "drd/tests/sem_as_mutex.vgtest",
    "drd/tests/sem_open2.vgtest",
    "drd/tests/sem_open3.vgtest",
    "drd/tests/sem_open_traced.vgtest",
    "drd/tests/sem_open.vgtest",
    "drd/tests/sem_wait.vgtest",
    "drd/tests/sigalrm.vgtest",
    "drd/tests/sigaltstack.vgtest",
    "drd/tests/std_thread.vgtest",
    "drd/tests/tc01_simple_race.vgtest",
    "drd/tests/tc02_simple_tls.vgtest",
    "drd/tests/tc03_re_excl.vgtest",
    "drd/tests/tc04_free_lock.vgtest",
    "drd/tests/tc05_simple_race.vgtest",
    "drd/tests/tc06_two_races.vgtest",
    "drd/tests/tc07_hbl1.vgtest",
    "drd/tests/tc08_hbl2.vgtest",
    "drd/tests/tc09_bad_unlock.vgtest",
    "drd/tests/tc10_rec_lock.vgtest",
    "drd/tests/tc11_XCHG.vgtest",
    "drd/tests/tc12_rwl_trivial.vgtest",
    "drd/tests/tc13_laog1.vgtest",
    "drd/tests/tc15_laog_lockdel.vgtest",
    "drd/tests/tc16_byterace.vgtest",
    "drd/tests/tc17_sembar.vgtest",
    "drd/tests/tc18_semabuse.vgtest",
    "drd/tests/tc19_shadowmem.vgtest",
    "drd/tests/tc21_pthonce.vgtest",
    "drd/tests/tc22_exit_w_lock.vgtest",
    "drd/tests/tc24_nonzero_sem.vgtest",
    "drd/tests/threaded-fork.vgtest",
    "drd/tests/thread_name.vgtest",
    "drd/tests/thread_name_xml.vgtest",
    "drd/tests/trylock.vgtest",
    "drd/tests/unit_bitmap.vgtest",
    "drd/tests/unit_vc.vgtest",
    "exp-bbv/tests/x86/complex_rep.vgtest",
    "exp-bbv/tests/x86/fldcw_check.vgtest",
    "exp-bbv/tests/x86-linux/clone_test.vgtest",
    "exp-bbv/tests/x86-linux/ll.vgtest",
    "exp-bbv/tests/x86/million.vgtest",
    "exp-bbv/tests/x86/rep_prefix.vgtest",
    "exp-sgcheck/tests/bad_percentify.vgtest",
    "exp-sgcheck/tests/globalerr.vgtest",
    "exp-sgcheck/tests/hackedbz2.vgtest",
    "exp-sgcheck/tests/hsg.vgtest",
    "exp-sgcheck/tests/preen_invars.vgtest",
    "exp-sgcheck/tests/stackerr.vgtest",
    "gdbserver_tests/mcblocklistsearch.vgtest",
    "gdbserver_tests/mcbreak.vgtest",
    "gdbserver_tests/mcclean_after_fork.vgtest",
#    "gdbserver_tests/mchelp.vgtest",
    "gdbserver_tests/mcinfcallRU.vgtest",
    "gdbserver_tests/mcinfcallWSRU.vgtest",
    "gdbserver_tests/mcinvokeRU.vgtest",
    "gdbserver_tests/mcinvokeWS.vgtest",
    "gdbserver_tests/mcleak.vgtest",
    "gdbserver_tests/mcmain_pic.vgtest",
    "gdbserver_tests/mcsignopass.vgtest",
    "gdbserver_tests/mcsigpass.vgtest",
    "gdbserver_tests/mcvabits.vgtest",
    "gdbserver_tests/mcwatchpoints.vgtest",
    "gdbserver_tests/mssnapshot.vgtest",
    "gdbserver_tests/nlcontrolc.vgtest",
    "gdbserver_tests/nlfork_chain.vgtest",
    "gdbserver_tests/nlpasssigalrm.vgtest",
    "gdbserver_tests/nlsigvgdb.vgtest",
    "helgrind/tests/annotate_hbefore.vgtest",
    "helgrind/tests/annotate_rwlock.vgtest",
    "helgrind/tests/annotate_smart_pointer.vgtest",
    "helgrind/tests/bar_bad.vgtest",
    "helgrind/tests/bar_trivial.vgtest",
    "helgrind/tests/cond_timedwait_invalid.vgtest",
    "helgrind/tests/free_is_write.vgtest",
    "helgrind/tests/hg01_all_ok.vgtest",
    "helgrind/tests/hg02_deadlock.vgtest",
    "helgrind/tests/hg03_inherit.vgtest",
    "helgrind/tests/hg04_race.vgtest",
    "helgrind/tests/hg05_race2.vgtest",
    "helgrind/tests/hg06_readshared.vgtest",
    "helgrind/tests/locked_vs_unlocked1_fwd.vgtest",
    "helgrind/tests/locked_vs_unlocked1_rev.vgtest",
    "helgrind/tests/locked_vs_unlocked2.vgtest",
    "helgrind/tests/locked_vs_unlocked3.vgtest",
    "helgrind/tests/pth_barrier1.vgtest",
    "helgrind/tests/pth_barrier2.vgtest",
    "helgrind/tests/pth_barrier3.vgtest",
    "helgrind/tests/pth_destroy_cond.vgtest",
    "helgrind/tests/pth_spinlock.vgtest",
    "helgrind/tests/rwlock_race.vgtest",
    "helgrind/tests/rwlock_test.vgtest",
    "helgrind/tests/t2t_laog.vgtest",
    "helgrind/tests/tc01_simple_race.vgtest",
    "helgrind/tests/tc02_simple_tls.vgtest",
    "helgrind/tests/tc03_re_excl.vgtest",
    "helgrind/tests/tc04_free_lock.vgtest",
    "helgrind/tests/tc05_simple_race.vgtest",
    "helgrind/tests/tc06_two_races.vgtest",
    "helgrind/tests/tc06_two_races_xml.vgtest",
    "helgrind/tests/tc07_hbl1.vgtest",
    "helgrind/tests/tc08_hbl2.vgtest",
    "helgrind/tests/tc09_bad_unlock.vgtest",
    "helgrind/tests/tc10_rec_lock.vgtest",
    "helgrind/tests/tc11_XCHG.vgtest",
    "helgrind/tests/tc12_rwl_trivial.vgtest",
    "helgrind/tests/tc13_laog1.vgtest",
    "helgrind/tests/tc14_laog_dinphils.vgtest",
    "helgrind/tests/tc15_laog_lockdel.vgtest",
    "helgrind/tests/tc16_byterace.vgtest",
    "helgrind/tests/tc17_sembar.vgtest",
    "helgrind/tests/tc18_semabuse.vgtest",
    "helgrind/tests/tc19_shadowmem.vgtest",
    "helgrind/tests/tc20_verifywrap.vgtest",
    "helgrind/tests/tc21_pthonce.vgtest",
    "helgrind/tests/tc22_exit_w_lock.vgtest",
    "helgrind/tests/tc24_nonzero_sem.vgtest",
    "lackey/tests/true.vgtest",
    "massif/tests/alloc-fns-A.vgtest",
    "massif/tests/alloc-fns-B.vgtest",
    "massif/tests/basic2.vgtest",
    "massif/tests/basic.vgtest",
    "massif/tests/big-alloc.vgtest",
    "massif/tests/culling1.vgtest",
    "massif/tests/culling2.vgtest",
    "massif/tests/custom_alloc.vgtest",
    "massif/tests/deep-A.vgtest",
    "massif/tests/deep-B.vgtest",
    "massif/tests/deep-C.vgtest",
    "massif/tests/deep-D.vgtest",
    "massif/tests/ignored.vgtest",
    "massif/tests/ignoring.vgtest",
    "massif/tests/insig.vgtest",
    "massif/tests/long-names.vgtest",
    "massif/tests/long-time.vgtest",
    "massif/tests/malloc_usable.vgtest",
    "massif/tests/new-cpp.vgtest",
    "massif/tests/no-stack-no-heap.vgtest",
    "massif/tests/null.vgtest",
    "massif/tests/one.vgtest",
    "massif/tests/overloaded-new.vgtest",
    "massif/tests/pages_as_heap.vgtest",
    "massif/tests/peak2.vgtest",
    "massif/tests/peak.vgtest",
    "massif/tests/realloc.vgtest",
    "massif/tests/thresholds_0_0.vgtest",
    "massif/tests/thresholds_0_10.vgtest",
    "massif/tests/thresholds_10_0.vgtest",
    "massif/tests/thresholds_10_10.vgtest",
    "massif/tests/thresholds_5_0.vgtest",
    "massif/tests/thresholds_5_10.vgtest",
    "massif/tests/zero1.vgtest",
    "massif/tests/zero2.vgtest",
    "memcheck/tests/accounting.vgtest",
    "memcheck/tests/addressable.vgtest",
    "memcheck/tests/atomic_incs.vgtest",
    "memcheck/tests/badaddrvalue.vgtest",
    "memcheck/tests/badfree-2trace.vgtest",
    "memcheck/tests/badfree.vgtest",
    "memcheck/tests/badjump2.vgtest",
    "memcheck/tests/badjump.vgtest",
    "memcheck/tests/badloop.vgtest",
    "memcheck/tests/badpoll.vgtest",
    "memcheck/tests/badrw.vgtest",
    "memcheck/tests/big_blocks_freed_list.vgtest",
    "memcheck/tests/brk2.vgtest",
    "memcheck/tests/buflen_check.vgtest",
    "memcheck/tests/bug287260.vgtest",
    "memcheck/tests/calloc-overflow.vgtest",
    "memcheck/tests/clientperm.vgtest",
    "memcheck/tests/clireq_nofill.vgtest",
    "memcheck/tests/clo_redzone_128.vgtest",
    "memcheck/tests/clo_redzone_default.vgtest",
    "memcheck/tests/custom_alloc.vgtest",
    "memcheck/tests/custom-overlap.vgtest",
    "memcheck/tests/deep-backtrace.vgtest",
    "memcheck/tests/deep_templates.vgtest",
    "memcheck/tests/describe-block.vgtest",
    "memcheck/tests/doublefree.vgtest",
    "memcheck/tests/dw4.vgtest",
    "memcheck/tests/err_disable1.vgtest",
    "memcheck/tests/err_disable2.vgtest",
    "memcheck/tests/err_disable3.vgtest",
    "memcheck/tests/err_disable4.vgtest",
    "memcheck/tests/erringfds.vgtest",
    "memcheck/tests/error_counts.vgtest",
    "memcheck/tests/errs1.vgtest",
    "memcheck/tests/execve1.vgtest",
    "memcheck/tests/execve2.vgtest",
    "memcheck/tests/exitprog.vgtest",
    "memcheck/tests/file_locking.vgtest",
    "memcheck/tests/fprw.vgtest",
    "memcheck/tests/fwrite.vgtest",
    "memcheck/tests/holey_buffer_too_small.vgtest",
    "memcheck/tests/inits.vgtest",
    "memcheck/tests/inline.vgtest",
    "memcheck/tests/leak-0.vgtest",
    "memcheck/tests/leak-cases-full.vgtest",
    "memcheck/tests/leak-cases-possible.vgtest",
    "memcheck/tests/leak-cases-summary.vgtest",
    "memcheck/tests/leak-cycle.vgtest",
    "memcheck/tests/leak-delta.vgtest",
    "memcheck/tests/leak-pool-0.vgtest",
    "memcheck/tests/leak-pool-1.vgtest",
    "memcheck/tests/leak-pool-2.vgtest",
    "memcheck/tests/leak-pool-3.vgtest",
    "memcheck/tests/leak-pool-4.vgtest",
    "memcheck/tests/leak-pool-5.vgtest",
    "memcheck/tests/leak-tree.vgtest",
    "memcheck/tests/linux/brk.vgtest",
    "memcheck/tests/linux/capget.vgtest",
    "memcheck/tests/linux/lsframe1.vgtest",
    "memcheck/tests/linux/lsframe2.vgtest",
    "memcheck/tests/linux/sigqueue.vgtest",
    "memcheck/tests/linux/stack_changes.vgtest",
    "memcheck/tests/linux/stack_switch.vgtest",
    "memcheck/tests/linux/syscalls-2007.vgtest",
    "memcheck/tests/linux/syslog-syscall.vgtest",
    "memcheck/tests/linux/with-space.vgtest",
    "memcheck/tests/long_namespace_xml.vgtest",
    "memcheck/tests/long-supps.vgtest",
    "memcheck/tests/mallinfo.vgtest",
    "memcheck/tests/malloc1.vgtest",
    "memcheck/tests/malloc2.vgtest",
    "memcheck/tests/malloc3.vgtest",
    "memcheck/tests/malloc_free_fill.vgtest",
    "memcheck/tests/malloc_usable.vgtest",
    "memcheck/tests/manuel1.vgtest",
    "memcheck/tests/manuel2.vgtest",
    "memcheck/tests/manuel3.vgtest",
    "memcheck/tests/match-overrun.vgtest",
    "memcheck/tests/memalign2.vgtest",
    "memcheck/tests/memalign_test.vgtest",
    "memcheck/tests/memcmptest.vgtest",
    "memcheck/tests/mempool2.vgtest",
    "memcheck/tests/mempool.vgtest",
    "memcheck/tests/metadata.vgtest",
    "memcheck/tests/mismatches.vgtest",
    "memcheck/tests/mmaptest.vgtest",
    "memcheck/tests/nanoleak2.vgtest",
    "memcheck/tests/nanoleak_supp.vgtest",
    "memcheck/tests/new_nothrow.vgtest",
    "memcheck/tests/new_override.vgtest",
    "memcheck/tests/noisy_child.vgtest",
    "memcheck/tests/null_socket.vgtest",
    "memcheck/tests/origin1-yes.vgtest",
    "memcheck/tests/origin2-not-quite.vgtest",
    "memcheck/tests/origin3-no.vgtest",
    "memcheck/tests/origin4-many.vgtest",
    "memcheck/tests/origin5-bz2.vgtest",
    "memcheck/tests/origin6-fp.vgtest",
    "memcheck/tests/overlap.vgtest",
    "memcheck/tests/partial_load_dflt.vgtest",
    "memcheck/tests/partial_load_ok.vgtest",
    "memcheck/tests/partiallydefinedeq.vgtest",
    "memcheck/tests/pdb-realloc2.vgtest",
    "memcheck/tests/pdb-realloc.vgtest",
    "memcheck/tests/pipe.vgtest",
    "memcheck/tests/pointer-trace.vgtest",
    "memcheck/tests/post-syscall.vgtest",
    "memcheck/tests/realloc1.vgtest",
    "memcheck/tests/realloc2.vgtest",
    "memcheck/tests/realloc3.vgtest",
    "memcheck/tests/sbfragment.vgtest",
    "memcheck/tests/sh-mem-random.vgtest",
    "memcheck/tests/sh-mem.vgtest",
    "memcheck/tests/sigaltstack.vgtest",
    "memcheck/tests/sigkill.vgtest",
    "memcheck/tests/signal2.vgtest",
    "memcheck/tests/sigprocmask.vgtest",
    "memcheck/tests/static_malloc.vgtest",
    "memcheck/tests/strchr.vgtest",
    "memcheck/tests/str_tester.vgtest",
    "memcheck/tests/supp1.vgtest",
    "memcheck/tests/supp2.vgtest",
    "memcheck/tests/supp-dir.vgtest",
    "memcheck/tests/suppfree.vgtest",
    "memcheck/tests/supp_unknown.vgtest",
    "memcheck/tests/test-plo-no.vgtest",
    "memcheck/tests/test-plo-yes.vgtest",
    "memcheck/tests/trivialleak.vgtest",
    "memcheck/tests/unit_libcbase.vgtest",
    "memcheck/tests/unit_oset.vgtest",
    "memcheck/tests/varinfo1.vgtest",
    "memcheck/tests/varinfo2.vgtest",
    "memcheck/tests/varinfo3.vgtest",
    "memcheck/tests/varinfo4.vgtest",
    "memcheck/tests/varinfo5.vgtest",
    "memcheck/tests/varinfo6.vgtest",
    "memcheck/tests/vcpu_bz2.vgtest",
    "memcheck/tests/vcpu_fbench.vgtest",
    "memcheck/tests/vcpu_fnfns.vgtest",
    "memcheck/tests/wrap1.vgtest",
    "memcheck/tests/wrap2.vgtest",
    "memcheck/tests/wrap3.vgtest",
    "memcheck/tests/wrap4.vgtest",
    "memcheck/tests/wrap5.vgtest",
    "memcheck/tests/wrap6.vgtest",
    "memcheck/tests/wrap7.vgtest",
    "memcheck/tests/wrap8.vgtest",
    "memcheck/tests/writev1.vgtest",
    "memcheck/tests/x86/bug152022.vgtest",
    "memcheck/tests/x86/espindola2.vgtest",
    "memcheck/tests/x86/fpeflags.vgtest",
    "memcheck/tests/x86/fprem.vgtest",
    "memcheck/tests/x86/fxsave.vgtest",
    "memcheck/tests/x86-linux/bug133694.vgtest",
    "memcheck/tests/x86-linux/int3-x86.vgtest",
    "memcheck/tests/x86-linux/scalar_exit_group.vgtest",
    "memcheck/tests/x86-linux/scalar_fork.vgtest",
    "memcheck/tests/x86-linux/scalar_supp.vgtest",
    "memcheck/tests/x86-linux/scalar_vfork.vgtest",
    "memcheck/tests/x86-linux/scalar.vgtest",
    "memcheck/tests/x86/more_x86_fp.vgtest",
    "memcheck/tests/x86/pushfpopf.vgtest",
    "memcheck/tests/x86/pushfw_x86.vgtest",
    "memcheck/tests/x86/pushpopmem.vgtest",
    "memcheck/tests/x86/sse1_memory.vgtest",
    "memcheck/tests/x86/sse2_memory.vgtest",
    "memcheck/tests/x86/tronical.vgtest",
    "memcheck/tests/x86/xor-undef-x86.vgtest",
    "memcheck/tests/xml1.vgtest",
    "none/tests/allexec32.vgtest",
    "none/tests/allexec64.vgtest",
    "none/tests/ansi.vgtest",
    "none/tests/args.vgtest",
    "none/tests/async-sigs.vgtest",
    "none/tests/bitfield1.vgtest",
    "none/tests/bug129866.vgtest",
    "none/tests/closeall.vgtest",
    "none/tests/cmdline0.vgtest",
    "none/tests/cmdline1.vgtest",
    "none/tests/cmdline2.vgtest",
    "none/tests/cmdline3.vgtest",
    "none/tests/cmdline4.vgtest",
    "none/tests/cmdline5.vgtest",
    "none/tests/cmdline6.vgtest",
    "none/tests/cmd-with-special.vgtest",
    "none/tests/coolo_sigaction.vgtest",
    "none/tests/coolo_strlen.vgtest",
    "none/tests/discard.vgtest",
    "none/tests/empty-exe.vgtest",
    "none/tests/exec-sigmask.vgtest",
    "none/tests/execve.vgtest",
    "none/tests/faultstatus.vgtest",
    "none/tests/fcntl_setown.vgtest",
    "none/tests/fdleak_cmsg.vgtest",
    "none/tests/fdleak_creat.vgtest",
    "none/tests/fdleak_dup2.vgtest",
    "none/tests/fdleak_dup.vgtest",
    "none/tests/fdleak_fcntl.vgtest",
    "none/tests/fdleak_ipv4.vgtest",
    "none/tests/fdleak_open.vgtest",
    "none/tests/fdleak_pipe.vgtest",
    "none/tests/fdleak_socketpair.vgtest",
    "none/tests/floored.vgtest",
    "none/tests/fork.vgtest",
    "none/tests/fucomip.vgtest",
    "none/tests/gxx304.vgtest",
    "none/tests/ifunc.vgtest",
    "none/tests/linux/blockfault.vgtest",
    "none/tests/linux/mremap2.vgtest",
    "none/tests/linux/mremap3.vgtest",
    "none/tests/linux/mremap.vgtest",
    "none/tests/manythreads.vgtest",
    "none/tests/map_unaligned.vgtest",
    "none/tests/map_unmap.vgtest",
    "none/tests/mmap_fcntl_bug.vgtest",
    "none/tests/mq.vgtest",
    "none/tests/munmap_exe.vgtest",
    "none/tests/nestedfns.vgtest",
    "none/tests/nodir.vgtest",
    "none/tests/pending.vgtest",
    "none/tests/process_vm_readv_writev.vgtest",
    "none/tests/procfs-linux.vgtest",
    "none/tests/procfs-non-linux.vgtest",
    "none/tests/pth_atfork1.vgtest",
    "none/tests/pth_blockedsig.vgtest",
    "none/tests/pth_cancel1.vgtest",
    "none/tests/pth_cancel2.vgtest",
    "none/tests/pth_cvsimple.vgtest",
    "none/tests/pth_empty.vgtest",
    "none/tests/pth_exit2.vgtest",
    "none/tests/pth_exit.vgtest",
    "none/tests/pth_mutexspeed.vgtest",
    "none/tests/pth_once.vgtest",
    "none/tests/pth_rwlock.vgtest",
    "none/tests/pth_stackalign.vgtest",
    "none/tests/rcrl.vgtest",
    "none/tests/readline1.vgtest",
    "none/tests/require-text-symbol-1.vgtest",
    "none/tests/require-text-symbol-2.vgtest",
    "none/tests/resolv.vgtest",
    "none/tests/res_search.vgtest",
    "none/tests/rlimit64_nofile.vgtest",
    "none/tests/rlimit_nofile.vgtest",
    "none/tests/selfrun.vgtest",
    "none/tests/semlimit.vgtest",
    "none/tests/sem.vgtest",
    "none/tests/sha1_test.vgtest",
    "none/tests/shell_badinterp.vgtest",
    "none/tests/shell_binaryfile.vgtest",
    "none/tests/shell_dir.vgtest",
    "none/tests/shell_nonexec.vgtest",
    "none/tests/shell_nosuchfile.vgtest",
    "none/tests/shell_valid1.vgtest",
    "none/tests/shell_valid2.vgtest",
    "none/tests/shell_valid3.vgtest",
    "none/tests/shell.vgtest",
    "none/tests/shell_zerolength.vgtest",
    "none/tests/shortpush.vgtest",
    "none/tests/shorts.vgtest",
    "none/tests/sigstackgrowth.vgtest",
    "none/tests/stackgrowth.vgtest",
    "none/tests/syscall-restart1.vgtest",
    "none/tests/syscall-restart2.vgtest",
    "none/tests/syslog.vgtest",
    "none/tests/system.vgtest",
    "none/tests/threadederrno.vgtest",
    "none/tests/threaded-fork.vgtest",
    "none/tests/thread-exits.vgtest",
    "none/tests/timestamp.vgtest",
    "none/tests/tls.vgtest",
    "none/tests/vgprintf.vgtest",
    "none/tests/x86/aad_aam.vgtest",
    "none/tests/x86/badseg.vgtest",
    "none/tests/x86/bt_everything.vgtest",
    "none/tests/x86/bt_literal.vgtest",
    "none/tests/x86/bug125959-x86.vgtest",
    "none/tests/x86/bug126147-x86.vgtest",
    "none/tests/x86/bug132813-x86.vgtest",
    "none/tests/x86/bug135421-x86.vgtest",
    "none/tests/x86/bug137714-x86.vgtest",
    "none/tests/x86/bug152818-x86.vgtest",
    "none/tests/x86/cmpxchg8b.vgtest",
    "none/tests/x86/cpuid.vgtest",
    "none/tests/x86/cse_fail.vgtest",
    "none/tests/x86/fcmovnu.vgtest",
    "none/tests/x86/fpu_lazy_eflags.vgtest",
    "none/tests/x86/fxtract.vgtest",
    "none/tests/x86/getseg.vgtest",
    "none/tests/x86/incdec_alt.vgtest",
    "none/tests/x86/insn_basic.vgtest",
    "none/tests/x86/insn_cmov.vgtest",
    "none/tests/x86/insn_fpu.vgtest",
    "none/tests/x86/insn_mmxext.vgtest",
    "none/tests/x86/insn_mmx.vgtest",
    "none/tests/x86/insn_sse2.vgtest",
    "none/tests/x86/insn_sse3.vgtest",
    "none/tests/x86/insn_sse.vgtest",
    "none/tests/x86/insn_ssse3.vgtest",
    "none/tests/x86/jcxz.vgtest",
    "none/tests/x86/lahf.vgtest",
    "none/tests/x86-linux/seg_override.vgtest",
    "none/tests/x86-linux/sigcontext.vgtest",
    "none/tests/x86/looper.vgtest",
    "none/tests/x86/lzcnt32.vgtest",
    "none/tests/x86/movbe.vgtest",
    "none/tests/x86/movx.vgtest",
    "none/tests/x86/pushpopseg.vgtest",
    "none/tests/x86/sbbmisc.vgtest",
    "none/tests/x86/shift_ndep.vgtest",
    "none/tests/x86/smc1.vgtest",
    "none/tests/x86/ssse3_misaligned.vgtest",
    "none/tests/x86/x86locked.vgtest",
    "none/tests/x86/xadd.vgtest"
    );

if (length($ARGV[0]) == 0)
{
    die "Must specify a test number";
}

my $length = scalar @tests;
#If the string "length" is the only argument, then return the number of test cases and exit without error.
if ($ARGV[0] =~ m/length/) { print $length; exit 0 }

my $num = $ARGV[0] - 1;
my $name = $tests[$num];

print $name;
print "\n";

if ($num < 0 || $num > $length)
{
    die "Invalid test number: $num";
}
my $result = system("perl tests/vg_regtest --keep-unfiltered $name &> /dev/null");
if ($result == 0)
{
    print STDERR "PASS: $num\t$name\n";
    exit 0;
}
else
{
    print STDERR "FAIL: $num\t$name\n";
    exit 1;
}