require 'formula'

class Libnet < Formula
  head 'git://github.com/sam-github/libnet.git'
  homepage 'http://github.com/sam-github/libnet'

  #
  # First patch of DATA stolen from macports, not sure what it does, fails to compile without:
  #   http://trac.macports.org/export/61844/trunk/dports/net/libnet11/files/patch-configure.in
  #
  # Second patch added to use glibtoolize instead of libtoolize, as OS X renames it.
  #
  def patches
    DATA
  end

  def install
    cd 'libnet'
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    touch 'doc/man/man3/libnet.3'
    system "make install"
  end
end

__END__
--- /libnet/configure.in.org	2006-08-30 07:53:09.000000000 -0700
+++ /libnet/configure.in	2006-08-30 07:54:01.000000000 -0700
@@ -158,6 +158,23 @@
 *darwin*)
     AC_DEFINE(HAVE_SOCKADDR_SA_LEN)
     LIBNET_CONFIG_DEFINES="-DHAVE_SOCKADDR_SA_LEN"
+
+dnl 
+dnl Check to see if x86
+dnl 
+
+    case "$target" in
+    i?86-*-*darwin*)
+        AC_DEFINE(LIBNET_BSDISH_OS)
+        AC_DEFINE(LIBNET_BSD_BYTE_SWAP)
+        LIBNET_CONFIG_DEFINES="$LIBNET_CONFIG_DEFINES -DLIBNET_BSDISH_OS -DLIBNET_BSD_BYTE_SWAP"
+        ;;
+
+    *)
+        ;;
+
+    esac
+
     ;;
 
 *solaris*)
--- /libnet/autogen.sh	2009-12-19 16:37:41.000000000 -0500
+++ /libnet/autogen.sh	2009-12-19 16:39:24.000000000 -0500
@@ -12,7 +12,7 @@
 set -e
 
 rm -fr autom4te.cache
-libtoolize --force
+glibtoolize --force
 aclocal -I . -I /sw/share/aclocal || aclocal -I .
 autoheader
 automake --foreign --force --add-missing --copy
