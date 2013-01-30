require 'formula'

class Pdf2htmlex < Formula
  homepage 'http://coolwanglu.github.com/pdf2htmlEX/'
  url 'https://github.com/coolwanglu/pdf2htmlEX/archive/v0.6.tar.gz'
  sha1 '3b824e007e48130ccacb7372fb98658990e402fd'

  head 'https://github.com/coolwanglu/pdf2htmlEX.git'

  depends_on 'cmake' => :build
  depends_on 'fontforge'
  depends_on 'libpng'
  depends_on 'ttfautohint'
  depends_on 'poppler'

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install"
  end

  def test
    mktemp do
      curl "-O", "http://partners.adobe.com/public/developer/en/xml/AdobeXMLFormsSamples.pdf"
      system "#{bin}/pdf2htmlEX", "AdobeXMLFormsSamples.pdf"
    end
  end
end
