require "formula"

class Sfcgal < Formula
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.0.5.tar.gz"
  sha256 "a9cdaf7334bf28dc71c6338d090c1d1402041c5e320b6c2e3669f7758946a01c"
  revision 1

  bottle do
    revision 2
    sha256 "bde77914aa67ba7ed3dfa4e8a30b23402debd2d7af096bfda0993da0cc3ed415" => :yosemite
    sha256 "4914911aa7131e1af7a29b29a9f2823fc23dd95c5ec561dd5be8fcec61af7508" => :mavericks
    sha256 "c22cb4901ec1f7ae8929deac5ce09da719490b2cc8d24b7467ea408e596819aa" => :mountain_lion
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
