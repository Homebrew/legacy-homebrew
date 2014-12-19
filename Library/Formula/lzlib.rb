require "formula"

class Lzlib < Formula
  homepage "http://www.nongnu.org/lzip/lzlib.html"
  url "http://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.6.tar.gz"
  sha1 "4a24e4d17df3fd90f53866ace922c831f26600f6"

  bottle do
    cellar :any
    revision 1
    sha1 "4b292d57f157ef8169b0aa7278708d8a902b7d72" => :yosemite
    sha1 "1ad7ec901c9b949b70934a3f40a4693bb09d37c8" => :mavericks
    sha1 "78a796e1a2c115b967ddde3fc014fb143bdfb351" => :mountain_lion
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
