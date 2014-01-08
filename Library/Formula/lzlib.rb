require 'formula'

class Lzlib < Formula
  homepage 'http://www.nongnu.org/lzip/lzlib.html'
  url 'http://download.savannah.gnu.org/releases/lzip/lzlib-1.5.tar.gz'
  sha1 'b89060b72c8357e0d0ca5198d48e97b5650a6d2c'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
