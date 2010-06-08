require 'formula'

class Djmount <Formula
  url 'http://downloads.sourceforge.net/project/djmount/djmount/0.71/djmount-0.71.tar.gz'
  homepage 'http://djmount.sourceforge.net/'
  md5 'c922753e706c194bf82a8b6ca77e6a9a'

  depends_on 'libupnp'

  def patches
    { :p0 => DATA }
  end

  def caveats
    <<-EOS.undent
    This depends on the MacFUSE installation from http://code.google.com/p/macfuse/
    MacFUSE must be installed prior to installing this formula.
    EOS
  end

  def install
    ENV.append "CFLAGS", "-D__FreeBSD__=10"
    system "./configure", "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-fuse-prefix=/usr/local",
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
