require 'formula'

# Tested on mac os x 10.8.2
# Changes to get this to compile:
#    - configure.ac used deprectated AM_CONFIG_HEADER, changed to AC_CONFIG_HEADERS
#    - Use of libpcsclite replaced with PCSC.framework:
#      - removed its flags from configure.ac and replaced with -framework PCSC
#      - download missing reader.h from Ludovic Rousseau's repository

class Cardpeek < Formula
  homepage 'http://code.google.com/p/cardpeek/'
  url 'http://cardpeek.googlecode.com/files/cardpeek-0.7.1.tar.gz'
  sha1 'f19feedc033c70e3373ee24d269295c4a33093d1'

  depends_on 'lua'
  depends_on 'gtk+'
  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on :x11

  def patches
    # Adds support for using mac PCSC framework in lieu of libpcsclite
    DATA
  end

  def install
    curl "http://anonscm.debian.org/viewvc/pcsclite/tags/PCSC/PCSC-1.8.8/src/PCSC/reader.h?view=co", "-o", "reader.h"
    system "autoreconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "cardpeek"
    man1.install 'cardpeek.1'
  end
end

__END__
diff --git i/configure.ac w/configure.ac
index b9a4977..a598a65 100644
--- i/configure.ac
+++ w/configure.ac
@@ -6,7 +6,7 @@ AC_INIT([cardpeek], [0.7.1], [L1L1@gmx.com])
 AM_INIT_AUTOMAKE([cardpeek], [0.7.1])
 
 AC_CONFIG_SRCDIR([main.c])
-AM_CONFIG_HEADER([config.h])
+AC_CONFIG_HEADERS([config.h])
 
 # Checks for programs.
 AC_PROG_CC
@@ -53,10 +53,9 @@ dnl
   AC_SUBST([$2_LIBS])
 ])
 
-AM_PATH_PACKAGE([libpcsclite],[PCSC],,AC_MSG_ERROR([
-Could not find libpcsclite-dev. 
-This program requires the libpcsclite library. 
-Please install the libpcsclite library first.]))
+PCSC_CFLAGS="-framework PCSC"
+AC_SUBST([PCSC_CFLAGS])
+AC_SUBST([PCSC_LIBS])
 
 AM_PATH_PACKAGE([lua-5.1],[LUA],,[
   AM_PATH_PACKAGE([lua5.1],[LUA],,[
diff --git i/drivers/pcsc_driver.c w/drivers/pcsc_driver.c
index 2b0590d..717dde4 100644
--- i/drivers/pcsc_driver.c
+++ w/drivers/pcsc_driver.c
@@ -19,9 +19,14 @@
 *
 */
 
-#include <winscard.h>
+#ifdef __APPLE__
+# include <PCSC/winscard.h>
+# include <PCSC/wintypes.h>
+#else
+# include <winscard.h>
+#endif
 #ifndef _WIN32
-#include <reader.h>
+# include "reader.h"
 #endif
 
 #define MAX_PCSC_READ_LENGTH 270 
diff --git i/script.S w/script.S
index 181b823..b089f5d 100644
--- i/script.S
+++ w/script.S
@@ -1,5 +1,5 @@
 	.data
-#ifdef _WIN32
+#if defined (_WIN32) || defined (__APPLE__)
 	.globl	__binary_dot_cardpeek_tar_gz_start
 	.globl  __binary_dot_cardpeek_tar_gz_size
 	.globl	__binary_dot_cardpeek_tar_gz_end

