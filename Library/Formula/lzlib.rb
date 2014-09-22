require "formula"

class Lzlib < Formula
  homepage "http://www.nongnu.org/lzip/lzlib.html"
  url "http://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.6.tar.gz"
  sha1 "4a24e4d17df3fd90f53866ace922c831f26600f6"

  bottle do
    cellar :any
    sha1 "9a805d032470d6d0f1f45fea1498e48709816bc7" => :mavericks
    sha1 "c6591a5842abc95dbfeec294555193b3e1cd85c7" => :mountain_lion
    sha1 "3e1261f5acf7ec50ea10dc55d6ed5e22368bf39c" => :lion
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
