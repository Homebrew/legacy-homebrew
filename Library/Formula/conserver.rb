require 'formula'

class Conserver < Formula
  homepage 'http://conserver.com'
  url 'http://conserver.com/conserver-8.1.19.tar.gz'
  sha1 'e13974427a91f3740057fb1170378021f311e7ac'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
