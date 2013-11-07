require 'formula'

class HtmlXmlUtils < Formula
  homepage 'http://www.w3.org/Tools/HTML-XML-utils/'
  url 'http://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-6.4.tar.gz'
  sha1 '6dc6ace41a4c3f692f79b16107d50d0e80d0ee40'

  def install
    ENV.append 'CFLAGS', '-std=gnu89'
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # install is not thread-safe
    system "make install"
  end
end
