require "formula"

class Plzip < Formula
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.2.tar.gz"
  sha1 "072f3253322ed36f96d452931780eea3dc7ec494"

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
