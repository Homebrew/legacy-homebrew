require "formula"

class Lzip < Formula
  homepage "http://www.nongnu.org/lzip/lzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/lzip-1.16.tar.gz"
  sha1 "5bcefbb788305db7be9748d3c0478156518f1025"

  bottle do
    cellar :any
    revision 1
    sha1 "c67e7822fbd4a7f2211b01fbfe85b7ada52ebfd5" => :yosemite
    sha1 "61fe16d13397bb6713c3e60ce72ec63656db6055" => :mavericks
    sha1 "6f8cb35b3a5068c83bc819c4c0d05d3fab366739" => :mountain_lion
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
