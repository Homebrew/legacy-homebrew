require 'formula'

class Pdf2htmlex < Formula
  homepage 'http://coolwanglu.github.com/pdf2htmlEX/'
  url 'https://github.com/coolwanglu/pdf2htmlEX/tarball/v0.3.1'
  sha1 '1ad2d9d1db10ce10721ffb38cbc692da32662bfe'

  head 'https://github.com/coolwanglu/pdf2htmlEX.git'

  depends_on 'cmake' => :build
  depends_on 'fontforge'
  depends_on 'libpng'
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
