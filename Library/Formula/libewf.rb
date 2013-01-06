require 'formula'

class Libewf < Formula
  homepage 'http://code.google.com/p/libewf/'
  url 'http://libewf.googlecode.com/files/libewf-20121209.tar.gz'
  sha1 '98870b307a6028788c76e572772965f15a84415a'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
