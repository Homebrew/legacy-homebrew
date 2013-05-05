require 'formula'

class Pdf2htmlex < Formula
  homepage 'http://coolwanglu.github.io/pdf2htmlEX/'
  url 'https://github.com/coolwanglu/pdf2htmlEX/archive/v0.8.tar.gz'
  sha256 '46b40c665d6d63d828bddada1683d36750ac5ba4ce15459ad9562ded145d8df2'

  head 'https://github.com/coolwanglu/pdf2htmlEX.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'fontforge'
  depends_on 'poppler'
  depends_on 'ttfautohint' => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install"
  end

  test do
    curl "-O", "http://partners.adobe.com/public/developer/en/xml/AdobeXMLFormsSamples.pdf"
    system "#{bin}/pdf2htmlEX", "AdobeXMLFormsSamples.pdf"
  end
end
