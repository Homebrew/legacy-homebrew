require 'formula'

class Cardpeek < Formula
  homepage 'https://cardpeek.googlecode.com'
  url 'https://cardpeek.googlecode.com/files/cardpeek-0.7.2.tar.gz'
  sha1 '9f774140bbfea2ebdd25f38146d7ebe3b1c0d871'
  head 'http://cardpeek.googlecode.com/svn/trunk/'

  depends_on 'pkg-config' => :build
  depends_on :automake => :build
  depends_on :x11
  depends_on 'gtk+'
  depends_on 'lua'

  def patches
    # only required for current stable build of 0.7.2. The head
    # version has full osx support.

    # patches copied from
    # https://code.google.com/p/cardpeek/issues/detail?id=24
    {:p0 => DATA} unless build.head?
  end

  def install
    # always run autoreconf, neeeded to generate configure for --HEAD,
    # and otherwise needed to reflect changes to configure.ac
    system "autoreconf -i"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
Index: configure.ac
===================================================================
--- configure.ac	(revision 228)
+++ configure.ac	(working copy)
@@ -14,6 +14,7 @@
 # Checks for programs.
 AC_PROG_CC
 AC_PROG_MAKE_SET
+AC_CANONICAL_HOST
 
 # Our own checks
 
@@ -57,10 +58,17 @@
   AC_SUBST([$2_LIBS])
 ])
 
+case "${host}" in
+  *-*-darwin*)
+    PCSC_CFLAGS='-framework PCSC -I/System/Library/Frameworks/PCSC.framework/Headers'
+    ;;
+  *)
 AM_PATH_PACKAGE([libpcsclite],[PCSC],,AC_MSG_ERROR([
 Could not find libpcsclite-dev. 
 This program requires the libpcsclite library. 
 Please install the libpcsclite library first.]))
+    ;;
+esac
 
 AM_PATH_PACKAGE([lua-5.1],[LUA],,[
   AM_PATH_PACKAGE([lua5.1],[LUA],,[
Index: script.S
===================================================================
--- script.S	(revision 228)
+++ script.S	(working copy)
@@ -1,5 +1,5 @@
 	.data
-#ifdef _WIN32
+#if defined _WIN32 || defined __APPLE__
 	.globl	__binary_dot_cardpeek_tar_gz_start
 	.globl  __binary_dot_cardpeek_tar_gz_size
 	.globl	__binary_dot_cardpeek_tar_gz_end
Index: drivers/pcsc_driver.c
===================================================================
--- drivers/pcsc_driver.c	(revision 228)
+++ drivers/pcsc_driver.c	(working copy)
@@ -22,7 +22,9 @@
 #include <winscard.h>
 
 #ifndef _WIN32
+#ifndef __APPLE__
 #include <reader.h>
+#endif
   SCARD_IO_REQUEST pioRecvPci_dummy;
 #define SCARD_PCI_NULL (&pioRecvPci_dummy)
 #else
@@ -33,6 +35,10 @@
    */
 #define SCARD_PCI_NULL NULL
 #endif
+#ifdef __APPLE__
+#include <wintypes.h>
+#define SCARD_ATTR_MAXINPUT 0x7A007
+#endif
 
 #define MAX_PCSC_READ_LENGTH 270 
 
