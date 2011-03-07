
require 'formula'

# broken in 3.00.  best to install training data manually
# class TesseractEnglishData <Formula
#   url 'http://tesseract-ocr.googlecode.com/files/eng.traineddata.gz'
#   md5 'd91041ad156cf2db36664e91ef799451'
#   version '3.00'
# end

class Tesseract <Formula
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-3.00.tar.gz'
  homepage 'http://code.google.com/p/tesseract-ocr/'
  md5 'cc812a261088ea0c3d2da735be35d09f'
  version '3.00'
  depends_on 'libtiff'

  def install
    fails_with_llvm "Executable 'tesseract' segfaults on 10.6 when compiled with llvm-gcc", :build => "2206"

    # 'make install' expects the language data files in the build directory
    d = Dir.getwd
    TesseractEnglishData.new.brew { cp Dir["*"], "#{d}/tessdata/" }

      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
        system "make install"
  end

  def caveats; <<-EOF.undent
    NOTE: Before running tesseract, you must install a language data file.
      For english:
        URL: http://tesseract-ocr.googlecode.com/files/eng.traineddata.gz
        MD5: d91041ad156cf2db36664e91ef799451
      `gunzip eng.trainneddata.gz `brew --prefix`/Cellar/tesseract/3.00/share/tessdata/`
    Tesseract is an OCR (Optical Character Recognition) engine.
      The easiest way to use it is to convert the source to a Grayscale tiff:
      `convert source.png -type Grayscale terre_input.tif`
    then run tesseract:
      `tesseract terre_input.tif output`
    EOF
  end
end
