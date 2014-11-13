require "formula"

class Plzip < Formula
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.2.tar.gz"
  sha1 "072f3253322ed36f96d452931780eea3dc7ec494"

  bottle do
    cellar :any
    sha1 "f9530aaba99fbd81804a9def33e781880a66d2e2" => :mavericks
    sha1 "0a2283e41795f32f2015ace63936b309df74aec9" => :mountain_lion
    sha1 "c9826ce05d1b5055a3ba5d20fae5c7d1cd4a091b" => :lion
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}", "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
