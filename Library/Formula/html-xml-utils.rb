require 'formula'

class HtmlXmlUtils < Formula
  url 'http://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-5.5.tar.gz'
  homepage 'http://www.w3.org/Tools/HTML-XML-utils/'
  sha1 'ec1e6d52825a6aa9e9aff0a34679621de5e419ba'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
