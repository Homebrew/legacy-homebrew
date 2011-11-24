require 'formula'

class TesseractEnglishData < Formula
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.01.eng.tar.gz'
  version '3.01'
  md5 '89c139a73e0e7b1225809fc7b226b6c9'
end

class Tesseract < Formula
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-3.01.tar.gz'
  homepage 'http://code.google.com/p/tesseract-ocr/'
  md5 '1ba496e51a42358fb9d3ffe781b2d20a'

  depends_on 'libtiff'
  depends_on 'leptonica'

  fails_with_llvm "Executable 'tesseract' segfaults on 10.6 when compiled with llvm-gcc", :build => "2206"

  # mftraining has a missing symbols error when cleaned
  skip_clean 'bin'

  def install
    system "/bin/sh autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    TesseractEnglishData.new.brew { mv Dir['tessdata/*'], "#{share}/tessdata/" }
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
