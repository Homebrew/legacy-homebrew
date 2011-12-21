require 'formula'

class Wkhtmltox < Formula
  url 'http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.11.0_rc1.tar.bz2'
  homepage 'http://code.google.com/p/wkhtmltopdf/'
  md5 '65378cf59698c676fcd6d8f5efd54be6'

  depends_on 'qt'

  def install
    inreplace "src/image/image.pro", "CONFIG += x86", "CONFIG += x86_64"
    inreplace "src/pdf/pdf.pro", "CONFIG += x86", "CONFIG += x86_64"
    system "qmake"
    system "make"
    lib.install Dir['bin/*.dylib']
    bin.install "bin/wkhtmltoimage"
    bin.install "bin/wkhtmltopdf"
  end

  def test
    system "wkhtmltoimage"
  end
end
