require "formula"

class Sfcgal < Formula
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.0.5.tar.gz"
  sha256 "a9cdaf7334bf28dc71c6338d090c1d1402041c5e320b6c2e3669f7758946a01c"
  revision 1

  bottle do
    revision 1
    sha1 "1a5ade35a1dcbe31b085e93c92fbe34f52f2239c" => :yosemite
    sha1 "eaa2e1ba6ec094304639b74a90e1f43897af5055" => :mavericks
    sha1 "904f9e44b4da3545d8bfec3fe862a1682cbdf25f" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
