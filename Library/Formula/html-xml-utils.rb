require 'formula'

class HtmlXmlUtils < Formula
  homepage 'http://www.w3.org/Tools/HTML-XML-utils/'
  url 'http://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-6.7.tar.gz'
  sha1 'f67fc705802ef0b10b9bf84c5b2fa4253b260acd'

  def install
    ENV.append 'CFLAGS', '-std=gnu89'
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # install is not thread-safe
    system "make install"
  end
end
