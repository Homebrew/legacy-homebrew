require 'formula'

class TesseractEnglishData <Formula
  url 'http://tesseract-ocr.googlecode.com/files/eng.traineddata.gz'
  md5 'd91041ad156cf2db36664e91ef799451'
  version '3.00'
end

class Tesseract <Formula
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-3.00.tar.gz'
  homepage 'http://code.google.com/p/tesseract-ocr/'
  md5 'cc812a261088ea0c3d2da735be35d09f'

  depends_on 'libtiff'

  def patches
    # add 16bpp support.
    DATA
  end

  def install
    fails_with_llvm "Executable 'tesseract' segfaults on 10.6 when compiled with llvm-gcc", :build => "2206"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    # 'make install' expects the language data files in the build directory
    tesseract_prefix = prefix
    TesseractEnglishData.new.brew do
      cp(Dir["*"], "#{tesseract_prefix}/share/tessdata/" )
    end
  end

  def caveats; <<-EOF.undent
    Tesseract is an OCR (Optical Character Recognition) engine.

    The easiest way to use it is to convert the source to a Grayscale tiff:
      `convert source.png -type Grayscale terre_input.tif`
    then run tesseract:
      `tesseract terre_input.tif output`
    EOF
  end
end

__END__
diff --git a/image/imgs.cpp b/image/imgs.cpp
index 0b6732d..a669ad7 100644
--- a/image/imgs.cpp
+++ b/image/imgs.cpp
@@ -252,7 +252,8 @@ inT32 check_legal_image_size(                     //get rest
   }
   if (bits_per_pixel != 1 && bits_per_pixel != 2
       && bits_per_pixel != 4 && bits_per_pixel != 5
-      && bits_per_pixel != 6 && bits_per_pixel != 8 && bits_per_pixel != 24
+      && bits_per_pixel != 6 && bits_per_pixel != 8
+      && bits_per_pixel != 16 && bits_per_pixel != 24
       && bits_per_pixel != 32) {
     BADBPP.error ("check_legal_image_size", TESSLOG, "%d", bits_per_pixel);
     return -1;
