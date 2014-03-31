require 'formula'

class Djmount < Formula
  homepage 'http://djmount.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/djmount/djmount/0.71/djmount-0.71.tar.gz'
  sha1 '527d4603d85b7fb86dc97d326b78c97bdcc4d687'

  depends_on 'pkg-config' => :build
  depends_on 'libupnp'
  depends_on 'osxfuse'

  patch :p0, :DATA

  def install
    ENV['FUSE_CFLAGS'] = `pkg-config fuse --cflags`.chomp
    ENV['FUSE_LIBS'] = `pkg-config fuse --libs`.chomp

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-external-libupnp",
                          "--with-libupnp-prefix=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end
end

__END__
diff -u -r djmount/cache.h djmount/cache.h
--- djmount/cache.h	2006-08-27 21:12:20.000000000 +0100
+++ djmount/cache.h	2009-06-01 07:52:19.000000000 +0100
@@ -25,6 +25,7 @@
 
 #include <stdlib.h>
 #include <stdbool.h>
+#include <time.h>
 
 
 /******************************************************************************
diff -u -r djmount/fuse_main.c djmount/fuse_main.c
--- djmount/fuse_main.c	2006-08-27 21:12:20.000000000 +0100
+++ djmount/fuse_main.c	2009-06-01 07:49:45.000000000 +0100
@@ -32,7 +32,7 @@
 #include <fcntl.h>
 #include <dirent.h>
 #include <errno.h>
-#include <sys/statfs.h>
+/*#include <sys/statfs.h>*/
 #ifdef HAVE_SETXATTR
 #	include <sys/xattr.h>
 #endif
diff -u -r djmount/test_device.c djmount/test_device.c
--- djmount/test_device.c	2006-08-27 21:12:20.000000000 +0100
+++ djmount/test_device.c	2009-06-01 08:02:05.000000000 +0100
@@ -27,6 +27,7 @@
 #include <stdio.h>
 #include "talloc_util.h"
 #include "log.h"
+#include "upnp/upnpdebug.h"
 
 
 #undef NDEBUG
@@ -62,7 +63,7 @@
 	Log_SetMaxLevel (LOG_ERROR);
 
 	// Manually initialise UPnP logs because UpnpInit() is not called
-	assert (InitLog() == UPNP_E_SUCCESS);
+	/*assert (UpnpInitLog() == UPNP_E_SUCCESS);*/
 
 	char buffer [10 * 1024];
 	char* const descDocText = fgets (buffer, sizeof (buffer), stdin);
diff -u -r djmount/test_vfs.c djmount/test_vfs.c
--- djmount/test_vfs.c	2006-08-27 21:12:20.000000000 +0100
+++ djmount/test_vfs.c	2009-06-01 08:03:03.000000000 +0100
@@ -31,7 +31,7 @@
 #include <fcntl.h>
 #include <dirent.h>
 #include <errno.h>
-#include <sys/statfs.h>
+/*#include <sys/statfs.h>*/
 #ifdef HAVE_SETXATTR
 #	include <sys/xattr.h>
 #endif
diff -u -r configure configure
--- configure	2006-08-27 21:13:13.000000000 +0100
+++ configure	2009-06-01 07:51:25.000000000 +0100
@@ -26489,7 +26489,7 @@
 
 
 
-FUSE_CFLAGS="$FUSE_CFLAGS -DFUSE_USE_VERSION=22"
+FUSE_CFLAGS="$FUSE_CFLAGS -DFUSE_USE_VERSION=25"
 
 
 #
--- djmount/upnp_util.h.orig	2006-08-27 20:12:20.000000000 +0000
+++ djmount/upnp_util.h
@@ -27,6 +27,7 @@
 #define UPNP_UTIL_H_INCLUDED
 
 
+#include <upnp/upnp.h>
 #include <upnp/upnptools.h>
 
 
@@ -46,8 +47,8 @@ extern "C" {
  *****************************************************************************/
 char*
 UpnpUtil_GetEventString (void* talloc_context,
-			 IN Upnp_EventType eventType, 
-			 IN const void* event);
+			 Upnp_EventType eventType, 
+			 const void* event);
 
 
 /*****************************************************************************
@@ -55,7 +56,7 @@ UpnpUtil_GetEventString (void* talloc_co
  * @return 	a static constant string, or NULL if unknown event type.
  *****************************************************************************/
 const char*
-UpnpUtil_GetEventTypeString (IN Upnp_EventType e);
+UpnpUtil_GetEventTypeString (Upnp_EventType e);
 
 
 
