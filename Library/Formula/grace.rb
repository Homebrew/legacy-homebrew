require 'formula'

class Grace < Formula
  homepage 'http://plasma-gate.weizmann.ac.il/Grace/'
  url 'ftp://plasma-gate.weizmann.ac.il/pub/grace/src/grace5/grace-5.1.22.tar.gz'
  sha1 '3ce88c7c264d2de73b8935f835a1c1f8e368c78f'

  depends_on :x11
  depends_on 'pdflib-lite'
  depends_on 'jpeg'
  depends_on 'fftw'
  depends_on 'lesstif'

  # Upstream development has stopped, but we provide a minimal patch that
  # allows compilation against libpng 1.5.
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib",
                          "--enable-grace-home=#{prefix}"

    system "make install"
  end
end

__END__
--- a/src/rstdrv.c
+++ b/src/rstdrv.c
@@ -54,6 +54,7 @@
 
 #ifdef HAVE_LIBPNG
 #  include <png.h>
+#  include <zlib.h>
 #endif
 
 #ifndef NONE_GUI
@@ -885,7 +886,7 @@ static void rstImagePng(gdImagePtr ihandle, FILE *prstream)
         return;
     }
 
-    if (setjmp(png_ptr->jmpbuf)) {
+    if (setjmp(png_jmpbuf(png_ptr))) {
         png_destroy_write_struct(&png_ptr, &info_ptr);
         return;
     }
