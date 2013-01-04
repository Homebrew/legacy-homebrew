require 'formula'

class Fcgi < Formula
  homepage 'http://www.fastcgi.com/'
  url 'http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz'
  sha1 '2329404159e8b8315e524b9eaf1de763202c6e6a'

  # Fixes "dyld: Symbol not found: _environ"
  # Affects programs linking this library. Reported at
  # http://mailman.fastcgi.com/pipermail/fastcgi-developers/2009-January/000152.html
  # https://trac.macports.org/browser/trunk/dports/www/fcgi/files/patch-libfcgi-fcgi_stdio.c.diff
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
--- acinclude.m4.orig  2001-12-20 20:12:50.000000000 -0700
+++ acinclude.m4	2009-01-18 23:50:28.000000000 -0700
@@ -1,6 +1,6 @@
 dnl     $Id: acinclude.m4,v 1.2 2001/12/21 03:12:50 robs Exp $
 
-AC_DEFUN(FCGI_COMMON_CHECKS, [
+AC_DEFUN([FCGI_COMMON_CHECKS], [
     AC_CHECK_TYPE([ssize_t], [int]) 
 
     AC_MSG_CHECKING([for sun_len in sys/un.h])
--- cgi-fcgi/cgi-fcgi.c.orig	2001-09-01 03:14:28.000000000 +0200
+++ cgi-fcgi/cgi-fcgi.c	2009-01-24 15:12:35.000000000 +0100
@@ -31,6 +31,9 @@
 #ifdef _WIN32
 #include <stdlib.h>
 #include <io.h>
+#elif defined(__APPLE__)
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron())
 #else
 extern char **environ;
 #endif
--- configure.in.orig	2003-01-19 10:19:41.000000000 -0700
+++ configure.in	2009-01-18 23:50:12.000000000 -0700
@@ -4,8 +4,8 @@
 dnl     generate the file "configure", which is run during the build
 dnl     to configure the system for the local environment.
 
-AC_INIT
-AM_INIT_AUTOMAKE(fcgi, 2.4.0)
+AC_INIT([fcgi],[2.4.0])
+AM_INIT_AUTOMAKE([-Wall -Werror foreign])
 
 AM_CONFIG_HEADER(fcgi_config.h)
 
--- libfcgi/Makefile.am.orig	2001-12-21 20:16:20.000000000 -0700
+++ libfcgi/Makefile.am	2009-01-18 23:57:40.000000000 -0700
@@ -18,10 +18,11 @@
                      os_@SYSTEM@.c
 libfcgi_la_CC      = @PTHREAD_CC@
 libfcgi_la_CFLAGS  = @PTHREAD_CFLAGS@
+libfcgi_la_LDFLAGS = -version-number $(subst .,:,@VERSION@)
 
 libfcgi___la_SOURCES = $(INCLUDE_FILES)       \
                        $(INCLUDEDIR)/fcgio.h  \
                        fcgio.cpp
 libfcgi___la_CFLAGS  = @PTHREAD_CFLAGS@
-libfcgi___la_LDFLAGS = -lfcgi -rpath @libdir@
+libfcgi___la_LDFLAGS = -lfcgi -rpath @libdir@ -version-number $(subst .,:,@VERSION@)
 
--- a/libfcgi/fcgi_stdio.c
+++ b/libfcgi/fcgi_stdio.c
@@ -40,7 +40,12 @@

 #ifndef _WIN32

+#if defined(__APPLE__)
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron())
+#else
 extern char **environ;
+#endif

 #ifdef HAVE_FILENO_PROTO
 #include <stdio.h>
