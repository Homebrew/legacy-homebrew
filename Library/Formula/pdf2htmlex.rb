require 'formula'

class Pdf2htmlex < Formula
  homepage 'http://coolwanglu.github.com/pdf2htmlEX/'
  url 'https://github.com/coolwanglu/pdf2htmlEX.git', :tag => 'v0.3.1'
  head 'https://github.com/coolwanglu/pdf2htmlEX.git'
  version 'v0.3.1'
  sha1 '325901f101b66e8b4959e3619dfe42a0068c0b09'

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
    system "curl http://partners.adobe.com/public/developer/en/xml/AdobeXMLFormsSamples.pdf -o /tmp/tmp.pdf && pdf2htmlEX /tmp/tmp.pdf"
  end
end
