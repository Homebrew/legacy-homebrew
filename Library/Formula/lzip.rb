require "formula"

class Lzip < Formula
  homepage "http://www.nongnu.org/lzip/lzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/lzip-1.16.tar.gz"
  sha1 "5bcefbb788305db7be9748d3c0478156518f1025"

  bottle do
    cellar :any
    sha1 "1d027a061ab2107a18bf2819d29d40318eaf106a" => :mavericks
    sha1 "8a3a453e1cc7d79d3cb6417a93e156edb44f7f9b" => :mountain_lion
    sha1 "3dbd0d6992d923a23ec3c25c04cb141a7bf3792a" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.j1
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system "#{bin}/lzip", path
    assert !path.exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
