require 'formula'

class Lzlib < Formula
  homepage 'http://www.nongnu.org/lzip/lzlib.html'
  url 'http://download.savannah.gnu.org/releases/lzip/lzlib-1.3.tar.gz'
  sha1 '788de95072cd2cf89d763b441a7fc76395193265'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
