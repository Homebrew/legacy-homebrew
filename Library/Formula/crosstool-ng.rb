require 'formula'

class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org'
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.19.0.tar.bz2'
  sha1 'b7ae3e90756b499ff5362064b7d80f8a45d09bfb'

  depends_on :automake
  depends_on 'coreutils' => :build
  depends_on 'wget'
  depends_on 'gnu-sed'
  depends_on 'gawk'
  depends_on 'binutils'
  depends_on 'libelf'
  depends_on 'grep' => '--default-names'

  env :std

  def patches
    # Fixes clang offsetof compatability. Took better patch from #14547
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--exec-prefix=#{prefix}",
                          "--with-objcopy=gobjcopy",
                          "--with-objdump=gobjdump",
                          "--with-readelf=greadelf",
                          "--with-libtool=glibtool",
                          "--with-libtoolize=glibtoolize",
                          "--with-install=ginstall",
                          "--with-sed=gsed",
                          "--with-awk=gawk",
                          "CFLAGS=-std=gnu89"
    # Must be done in two steps
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    You will need to install modern gcc compiler (such as 4.7) in order to use this tool.

    Ensure that gsed, gawk and grep returns GNU versions of the utilities before using the tool.

    Ensure that limit of max open file descriptors is suffician (e.g. `ulimit -n 2048`).

    If your file system is key insesensetive, you will need to create 2 disk images via Disk Utility
    with the "Mac OS Extended (Case-sensitive, Journaled)" FS. One drive (~11GB) should be used to build tools and
    another drive (~200MB) should be used to install tools.

    If toolchain building process ends with error due to missing "libintl.h", try to install gettext
    and link it via `brew link --force`.
    EOS
  end

  test do
    system "#{bin}/ct-ng", "version"
  end
end

__END__
diff --git a/kconfig/zconf.gperf b/kconfig/zconf.gperf
index c9e690e..21e79e4 100644
--- a/kconfig/zconf.gperf
+++ b/kconfig/zconf.gperf
@@ -7,6 +7,10 @@
 %pic
 %struct-type

+%{
+#include <stddef.h>
+%}
+
 struct kconf_id;

 static struct kconf_id *kconf_id_lookup(register const char *str, register unsigned int len);

 diff -r fcdf7fc7fd1c -r 0926f7ff958a patches/eglibc/2_17/osx_do_not_redefine_types_sunrpc.patch
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/patches/eglibc/2_17/osx_do_not_redefine_types_sunrpc.patch  Tue Mar 26 14:28:49 2013 +0200
@@ -0,0 +1,39 @@
+Apple already defines the u_char, u_short, etc. types in <sys/types.h>.
+However, those are defined directly, without using the __u_char types.
+
+diff -Naur eglibc-2_17-old/sunrpc/rpc/types.h eglibc-2_17-new/sunrpc/rpc/types.h
+--- eglibc-2_17-old/sunrpc/rpc/types.h 2010-08-19 23:32:31.000000000 +0300
++++ eglibc-2_17-new/sunrpc/rpc/types.h 2013-03-26 01:16:16.000000000 +0200
+@@ -69,7 +69,11 @@
+ #include <sys/types.h>
+ #endif
+ 
+-#ifndef __u_char_defined
++/*
++ * OS X already has these <sys/types.h>
++ */
++#ifndef __APPLE__
++# ifndef __u_char_defined
+ typedef __u_char u_char;
+ typedef __u_short u_short;
+ typedef __u_int u_int;
+@@ -77,13 +81,14 @@
+ typedef __quad_t quad_t;
+ typedef __u_quad_t u_quad_t;
+ typedef __fsid_t fsid_t;
+-# define __u_char_defined
+-#endif
+-#ifndef __daddr_t_defined
++#  define __u_char_defined
++# endif
++# ifndef __daddr_t_defined
+ typedef __daddr_t daddr_t;
+ typedef __caddr_t caddr_t;
+-# define __daddr_t_defined
+-#endif
++#  define __daddr_t_defined
++# endif
++#endif /* __APPLE__ */
+ 
+ #include <sys/time.h>
+ #include <sys/param.h>
