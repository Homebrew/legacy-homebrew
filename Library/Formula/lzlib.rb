require "formula"

class Lzlib < Formula
  homepage "http://www.nongnu.org/lzip/lzlib.html"
  url "http://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.6.tar.gz"
  sha1 "4a24e4d17df3fd90f53866ace922c831f26600f6"

  bottle do
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
