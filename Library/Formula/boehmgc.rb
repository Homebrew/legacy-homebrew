require 'formula'

class Boehmgc <Formula
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.1.tar.gz'
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
  md5 '2ff9924c7249ef7f736ecfe6f08f3f9b'

  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/mach_dep.c
+++ b/mach_dep.c
@@ -160,7 +160,7 @@ void GC_push_regs()
 #endif
 
 #if !defined(HAVE_PUSH_REGS) && defined(UNIX_LIKE)
-# include <ucontext.h>
+# include <sys/ucontext.h>
 #endif
 
 /* Ensure that either registers are pushed, or callee-save registers   */
--- a/os_dep.c
+++ b/os_dep.c
@@ -2752,7 +2752,7 @@ GC_bool GC_old_segv_handler_used_si;
 # if defined(MSWIN32) || defined(MSWINCE)
     LONG WINAPI GC_write_fault_handler(struct _EXCEPTION_POINTERS *exc_info)
 # else
-#   include <ucontext.h>
+#   include <sys/ucontext.h>
     /*ARGSUSED*/
     void GC_write_fault_handler(int sig, siginfo_t *si, void *raw_sc)
 # endif /* MSWIN32 || MSWINCE */
