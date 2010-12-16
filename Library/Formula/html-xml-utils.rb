require 'formula'

class HtmlXmlUtils <Formula
  url 'http://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-5.5.tar.gz'
  homepage 'http://www.w3.org/Tools/HTML-XML-utils/'
  md5 '28c58add86e35a60e602a029c8e2f04b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
