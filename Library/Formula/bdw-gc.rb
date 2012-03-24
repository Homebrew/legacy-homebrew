require 'formula'

# Upstream recommends using 7.2alpha6 over 7.1
class BdwGc < Formula
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2alpha6.tar.gz'
  md5 '319d0b18cc4eb735c8038ece9df055e4'
  version '7.2alpha6'

  # fix inline ASM issues with LLVM and Makefile double-install
  # both fixes already upstream
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make check"
    system "make install"
  end
end

__END__
diff --git a/libatomic_ops/src/atomic_ops/sysdeps/gcc/x86.h b/libatomic_ops/src/atomic_ops/sysdeps/gcc/x86.h
index 5e6d7fa..c0845ba 100644
--- a/libatomic_ops/src/atomic_ops/sysdeps/gcc/x86.h
+++ b/libatomic_ops/src/atomic_ops/sysdeps/gcc/x86.h
@@ -113,7 +113,7 @@ AO_test_and_set_full(volatile AO_TS_t *addr)
   /* Note: the "xchg" instruction does not need a "lock" prefix */
   __asm__ __volatile__("xchgb %0, %1"
                 : "=q"(oldval), "=m"(*addr)
-                : "0"(0xff), "m"(*addr) : "memory");
+                : "0"((unsigned char)0xff), "m"(*addr) : "memory");
   return (AO_TS_VAL_t)oldval;
 }
 #define AO_HAVE_test_and_set_full
diff --git a/libatomic_ops/src/atomic_ops/sysdeps/gcc/x86_64.h b/libatomic_ops/src/atomic_ops/sysdeps/gcc/x86_64.h
index 0f68c1e..b3b57f9 100644
--- a/libatomic_ops/src/atomic_ops/sysdeps/gcc/x86_64.h
+++ b/libatomic_ops/src/atomic_ops/sysdeps/gcc/x86_64.h
@@ -110,7 +110,7 @@ AO_test_and_set_full(volatile AO_TS_t *addr)
   /* Note: the "xchg" instruction does not need a "lock" prefix */
   __asm__ __volatile__("xchgb %0, %1"
                 : "=q"(oldval), "=m"(*addr)
-                : "0"(0xff), "m"(*addr) : "memory");
+                : "0"((unsigned char)0xff), "m"(*addr) : "memory");
   return (AO_TS_VAL_t)oldval;
 }
 #define AO_HAVE_test_and_set_full

diff --git a/Makefile.in b/Makefile.in
index 09dea13..1f4356e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -108,7 +108,6 @@ check_PROGRAMS = gctest$(EXEEXT) leaktest$(EXEEXT) middletest$(EXEEXT) \
 # C++ Interface
 # -------------
 @CPLUSPLUS_TRUE@am__append_5 = libgccpp.la
-@CPLUSPLUS_TRUE@am__append_6 = include/gc_cpp.h include/gc_allocator.h
 DIST_COMMON = $(am__configure_deps) $(am__pkginclude_HEADERS_DIST) \
 	$(dist_noinst_HEADERS) $(dist_noinst_SCRIPTS) \
 	$(dist_pkgdata_DATA) $(include_HEADERS) $(srcdir)/Makefile.am \
@@ -579,7 +578,7 @@ include_HEADERS = include/extra/gc.h include/extra/gc_cpp.h
 
 # installed headers
 #
-pkginclude_HEADERS = $(am__append_6) include/gc.h include/gc_typed.h \
+pkginclude_HEADERS = include/gc.h include/gc_typed.h \
 	include/gc_inline.h include/gc_mark.h include/gc_cpp.h \
 	include/weakpointer.h include/new_gc_alloc.h \
 	include/gc_allocator.h include/gc_backptr.h include/gc_gcj.h \
