require 'formula'

class Pdf2htmlex < Formula
  homepage 'http://coolwanglu.github.com/pdf2htmlEX/'
  url 'https://github.com/coolwanglu/pdf2htmlEX/archive/v0.7.tar.gz'
  sha1 'c93498d0251313fb7a003ff0b59f11d07759fb7e'

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
