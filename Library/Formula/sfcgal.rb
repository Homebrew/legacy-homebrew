require "formula"

class Sfcgal < Formula
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.0.4.tar.gz"
  sha256 "f4660631bf42e2ed3f8b06bcd7a083f3f25e8a860a902bbb4687c60fcde1e131"

  bottle do
    cellar :any
    sha1 "524a95c8fa7ab6a3a91fa0a64afcb68741e9e6c2" => :mavericks
    sha1 "cf4160102e93cfc11d67db0bb64c2d3697cfef1f" => :mountain_lion
    sha1 "3d957de66ac9262d61f7a0357b67e407b1961ea7" => :lion
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
