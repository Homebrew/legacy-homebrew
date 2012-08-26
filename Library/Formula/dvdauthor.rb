require 'formula'

class Dvdauthor < Formula
  homepage 'http://dvdauthor.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/dvdauthor/dvdauthor/0.7.0/dvdauthor-0.7.0.tar.gz'
  sha1 '39501f826ae9cc6b334160ebb9c01ce9c91b31d4'

  # Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
  # But we don't add either as deps because they are big.

  depends_on 'pkg-config' => :build
  depends_on 'libdvdread'
  depends_on :freetype

  # Fix build with png-1.5. Patch has been applied upstream, but no tagged
  # release has been made since 2010. See:
  # http://bugs.gentoo.org/355039
  # https://github.com/ldo/dvdauthor/commit/c82aaa4eb1a1c36bf7e2b7ae3c9140d0bf8000b5
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.j1 # Install isn't parallel-safe
    system "make install"
  end
end

__END__
--- a/src/spuunmux.c	2010-05-10 11:27:55.000000000 +0400
+++ b/src/spuunmux.c	2011-03-17 11:20:25.000000000 +0300
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
