require 'formula'

class BdwGc < Formula
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'

  if ARGV.build_devel?
    url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2alpha6.tar.gz'
    md5 '319d0b18cc4eb735c8038ece9df055e4'
    version '7.2alpha6'
  else
    url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.1.tar.gz'
    md5 '2ff9924c7249ef7f736ecfe6f08f3f9b'
  end

  # patch to fix inline asm errors with LLVM, present in upstream SVN
  # some directory restructuring between 7.1 and 7.2a6 force us to have two
  # versions of the same patch
  def patches
    if ARGV.build_devel?
      DATA
    else
      { :p0 => "https://trac.macports.org/export/86621/trunk/dports/devel/boehmgc/files/asm.patch" }
    end
  end

  def install
    # ucontext has been deprecated in 10.6
    # use this flag to force the header to compile
    ENV.append 'CPPFLAGS', "-D_XOPEN_SOURCE" if MacOS.snow_leopard?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
