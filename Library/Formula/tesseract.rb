require 'formula'

class TesseractEnglishData <Formula
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-2.00.eng.tar.gz'
  md5 'b8291d6b3a63ce7879d688e845e341a9'
  version '2.00'
end

class Tesseract <Formula
  url 'http://tesseract-ocr.googlecode.com/files/tesseract-2.04.tar.gz'
  homepage 'http://code.google.com/p/tesseract-ocr/'
  md5 'b44eba1a9f4892ac62e484c807fe0533'

  depends_on 'libtiff'

  def install
    # 'make install' expects the language data files in the build directory
    d = Dir.getwd
    TesseractEnglishData.new.brew { FileUtils.cp Dir["*"], "#{d}/tessdata/" }

    ENV.O3
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
