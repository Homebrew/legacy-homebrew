require 'formula'

class TesseractEnglishData < Formula
  url 'http://tesseract-ocr.googlecode.com/files/eng.traineddata.gz',
      :using => GzipOnlyDownloadStrategy
  md5 'd91041ad156cf2db36664e91ef799451'
  version '3.00'
end

class Tesseract < Formula
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-3.00.tar.gz'
  homepage 'http://code.google.com/p/tesseract-ocr/'
  md5 'cc812a261088ea0c3d2da735be35d09f'

  depends_on 'libtiff'

  fails_with_llvm "Executable 'tesseract' segfaults on 10.6 when compiled with llvm-gcc", :build => "2206"

  # mftraining has a missing symbols error when cleaned
  skip_clean 'bin'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    TesseractEnglishData.new.brew { mv "eng.traineddata", "#{share}/tessdata/" }
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
