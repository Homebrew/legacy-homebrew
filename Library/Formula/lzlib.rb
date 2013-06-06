require 'formula'

class Lzlib < Formula
  homepage 'http://www.nongnu.org/lzip/lzlib.html'
  url 'http://download.savannah.gnu.org/releases/lzip/lzlib-1.4.tar.gz'
  sha1 '94aa4558f499ef64603f329d2a9ba9d2612674da'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
