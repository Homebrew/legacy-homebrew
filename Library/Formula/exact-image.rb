require 'formula'

class ExactImage < Formula
  homepage 'http://www.exactcode.de/site/open_source/exactimage/'
  head 'https://svn.exactcode.de/exact-image/trunk'

  depends_on :x11
  depends_on 'freetype'
  depends_on 'libagg' => 'with-freetype'
  depends_on 'pkg-config' => :build
  depends_on 'libpng' => :optional
  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def patches
    # fixes a problem with double inclusion of "lib/scale.hh" in various cc files
    DATA
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-libpng" unless build.with? 'libpng'
    args << "--without-libjpeg" unless build.with? 'jpeg'
    args << "--without-libtiff" unless build.with? 'libtiff'

    system "./configure", *args
    system "make", "install"
  end
end

__END__
diff --git a/lib/scale.hh b/lib/scale.hh
index 0b9f75a..f3329c1 100644
--- a/lib/scale.hh
+++ b/lib/scale.hh
@@ -16,6 +16,9 @@
  * copyright holder ExactCODE GmbH Germany.
  */
 
+#ifndef _SCALE_HH
+#define _SCALE_HH
+
 // pick the best
 void scale (Image& image, double xscale, double yscale);
 
@@ -29,3 +32,5 @@ void bicubic_scale (Image& image, double xscale, double yscale);
 void ddt_scale (Image& image, double xscale, double yscale);
 
 void thumbnail_scale (Image& image, double xscale, double yscale);
+
+#endif

