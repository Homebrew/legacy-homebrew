require 'formula'

class ExactImage < Formula
  homepage 'http://www.exactcode.de/site/open_source/exactimage/'
  url 'http://dl.exactcode.de/oss/exact-image/exact-image-0.8.9.tar.bz2'
  sha1 'd68edb48df333d31b3f87723e487d1b3ee45fdbf'

  depends_on :x11
  depends_on 'freetype'
  depends_on 'libagg' => 'with-freetype'
  depends_on 'pkg-config' => :build
  depends_on 'libpng' => :optional
  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def patches
    # fixes exact-image to adhere to libPNG 1.4+ APIs
    DATA
  end

  def install
    args = ["--prefix=#{prefix}",
            "--without-python",
            "--without-perl",
            "--without-php",
            "--without-libungif"]
    args << "--without-libpng" unless build.with? 'libpng'
    args << "--without-libjpeg" unless build.with? 'jpeg'
    args << "--without-libtiff" unless build.with? 'libtiff'

    system "./configure", *args
    system "make", "install"
  end
end

__END__
diff --git a/codecs/png.cc b/codecs/png.cc
index be70a53..65cee67 100644
--- a/codecs/png.cc
+++ b/codecs/png.cc
@@ -23,6 +23,12 @@
 #include "png.hh"
 #include "Endianess.hh"
 
+#define png_infopp_NULL (png_infopp)NULL
+#define int_p_NULL (int*)NULL
+#define png_bytepp_NULL (png_bytepp)NULL
+#define Z_BEST_COMPRESSION 100
+
+
 void stdstream_read_data(png_structp png_ptr,
 			 png_bytep data, png_size_t length)
 {
@@ -104,7 +110,8 @@ int PNGCodec::readImage (std::istream* stream, Image& image, const std::string&
   image.w = width;
   image.h = height;
   image.bps = bit_depth;
-  image.spp = info_ptr->channels;
+//  image.spp = info_ptr->channels;
+  image.spp = png_get_channels(png_ptr, info_ptr);
   
   png_uint_32 res_x, res_y;
   res_x = png_get_x_pixels_per_meter(png_ptr, info_ptr);
@@ -123,7 +130,13 @@ int PNGCodec::readImage (std::istream* stream, Image& image, const std::string&
   if (color_type == PNG_COLOR_TYPE_PALETTE) {
     png_set_palette_to_rgb(png_ptr);
     image.bps = 8;
-    if (info_ptr->num_trans)
+
+    png_bytep trans_alpha;
+    int num_trans;
+    png_color_16p trans_color;
+    png_get_tRNS(png_ptr, info_ptr, &trans_alpha,
+                         &num_trans, &trans_color);
+    if (num_trans)
       image.spp = 4;
     else
       image.spp = 3;
@@ -244,7 +257,7 @@ bool PNGCodec::writeImage (std::ostream* stream, Image& image, int quality,
   else if (quality > Z_BEST_COMPRESSION) quality = Z_BEST_COMPRESSION;
   png_set_compression_level(png_ptr, quality);
   
-  png_info_init (info_ptr);
+  //png_info_init (info_ptr);
   
   /* Set up our STL stream output control */ 
   png_set_write_fn (png_ptr, stream, &stdstream_write_data, &stdstream_flush_data);

