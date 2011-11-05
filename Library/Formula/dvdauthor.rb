require 'formula'

# Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
# But we don't add either as deps because they are big.

class Dvdauthor < Formula
  url 'http://downloads.sourceforge.net/project/dvdauthor/dvdauthor/0.7.0/dvdauthor-0.7.0.tar.gz'
  homepage 'http://dvdauthor.sourceforge.net/'
  md5 '33a447fb98ab3293ac40f869eedc17ff'

  depends_on 'pkg-config' => :build
  depends_on 'libdvdread'

  def patches
    { :p0 => DATA }
  end

  def install
    ENV.x11 # For libpng, etc.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.j1 # Install isn't parallel-safe
    system "make install"
  end
end

__END__
http://bugs.gentoo.org/355039
Fix build with png-1.5.

--- src/spuunmux.c.orig	2010-05-10 11:27:55.000000000 +0400
+++ src/spuunmux.c	2011-03-17 11:20:25.000000000 +0300
@@ -39,6 +39,7 @@
 #include <netinet/in.h>
 
 #include <png.h>
+#include <zlib.h>
 
 #include "rgb.h"
 #include "common.h"
@@ -610,7 +611,7 @@
         png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
         return -1;
       } /*if*/
-    if (setjmp(png_ptr->jmpbuf))
+    if (setjmp(png_jmpbuf(png_ptr)))
       {
         png_destroy_write_struct(&png_ptr, &info_ptr);
         fclose(fp);
