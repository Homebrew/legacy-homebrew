require 'formula'

class Uriparser < Formula
  homepage 'http://uriparser.sourceforge.net/'
  url 'http://sourceforge.net/projects/uriparser/files/Sources/0.7.8/uriparser-0.7.8.tar.bz2'
  sha1 '36fb3f12e06788d46c51145bba715e5dadb5b207'

  depends_on 'pkg-config' => :build
  depends_on 'cpptest'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make check"
    system "make install"
  end
end
