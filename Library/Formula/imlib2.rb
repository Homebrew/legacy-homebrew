require 'formula'

class Imlib2 < Formula
  url 'http://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.4/imlib2-1.4.4.tar.bz2'
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  md5 'b6de51879502e857d5b1f7622267a030'

  depends_on 'pkg-config' => :build

  # Returns integer xxyyzz, where x=major, y=minor, z=release
  def libpng_version
    File.read('/usr/X11/include/png.h')[/^\#define\s+PNG_LIBPNG_VER\s+(\d+)/, 1].to_i
  end

  # NOTE: Patch is included in dev branch, so remove when updating
  def patches
    DATA unless libpng_version < 10500
  end

  def install
    ENV.x11 # For freetype
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-amd64=no"
    system "make install"
  end
end

__END__
Patch by Thomas Klausner

http://sourceforge.net/mailarchive/message.php?msg_id=26972342

$NetBSD: patch-af,v 1.4 2011/01/14 10:02:54 wiz Exp $

Fix build with png-1.5.

--- a/src/modules/loaders/loader_png.c.orig	2010-02-08 00:29:06.000000000 -0800
+++ b/src/modules/loaders/loader_png.c	2010-02-08 00:34:14.000000000 -0800
@@ -58,7 +58,7 @@
              fclose(f);
              return 0;
           }
-        if (setjmp(png_ptr->jmpbuf))
+        if (setjmp(png_jmpbuf(png_ptr)))
           {
              png_destroy_read_struct(&png_ptr, &info_ptr, NULL);
              fclose(f);
@@ -238,7 +238,7 @@
    png_structp         png_ptr;
    png_infop           info_ptr;
    DATA32             *ptr;
-   int                 x, y, j;
+   int                 x, y, j, interlace;
    png_bytep           row_ptr, data = NULL;
    png_color_8         sig_bit;
    int                 pl = 0;
@@ -265,7 +265,7 @@
         png_destroy_write_struct(&png_ptr, (png_infopp) NULL);
         return 0;
      }
-   if (setjmp(png_ptr->jmpbuf))
+   if (setjmp(png_jmpbuf(png_ptr)))
      {
         fclose(f);
         png_destroy_write_struct(&png_ptr, (png_infopp) & info_ptr);
@@ -274,11 +274,11 @@
      }
 
    /* check whether we should use interlacing */
+   interlace = PNG_INTERLACE_NONE;
    if ((tag = __imlib_GetTag(im, "interlacing")) && tag->val)
      {
 #ifdef PNG_WRITE_INTERLACING_SUPPORTED
-          png_ptr->interlaced = PNG_INTERLACE_ADAM7;
-          num_passes = png_set_interlace_handling(png_ptr);
+	  interlace = PNG_INTERLACE_ADAM7;
 #endif
      }
 
@@ -286,7 +286,7 @@
    if (im->flags & F_HAS_ALPHA)
      {
         png_set_IHDR(png_ptr, info_ptr, im->w, im->h, 8,
-                     PNG_COLOR_TYPE_RGB_ALPHA, png_ptr->interlaced,
+                     PNG_COLOR_TYPE_RGB_ALPHA, interlace,
                      PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);
 #ifdef WORDS_BIGENDIAN
         png_set_swap_alpha(png_ptr);
@@ -297,7 +297,7 @@
    else
      {
         png_set_IHDR(png_ptr, info_ptr, im->w, im->h, 8, PNG_COLOR_TYPE_RGB,
-                     png_ptr->interlaced, PNG_COMPRESSION_TYPE_BASE,
+                     interlace, PNG_COMPRESSION_TYPE_BASE,
                      PNG_FILTER_TYPE_BASE);
         data = malloc(im->w * 3 * sizeof(char));
      }
@@ -344,6 +344,10 @@
    png_set_shift(png_ptr, &sig_bit);
    png_set_packing(png_ptr);
 
+#ifdef PNG_WRITE_INTERLACING_SUPPORTED
+     num_passes = png_set_interlace_handling(png_ptr);
+#endif
+
    for (pass = 0; pass < num_passes; pass++)
      {
       ptr = im->data;
