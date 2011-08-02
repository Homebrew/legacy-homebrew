require 'formula'

class Uriparser < Formula
  url 'http://downloads.sourceforge.net/project/uriparser/Sources/0.7.5/uriparser-0.7.5.tar.gz'
  homepage 'http://uriparser.sourceforge.net/'
  md5 '459c2786758929b92bfbd0cee25b5aa0'

  depends_on 'cpptest'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-doc"
    system "make check"
    system "make install"
  end
end
