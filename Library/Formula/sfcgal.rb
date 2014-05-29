require "formula"

class Sfcgal < Formula
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.0.4.tar.gz"
  sha256 "f4660631bf42e2ed3f8b06bcd7a083f3f25e8a860a902bbb4687c60fcde1e131"

  depends_on "cmake" => :build
  depends_on "cgal"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
