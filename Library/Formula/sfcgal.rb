require "formula"

class Sfcgal < Formula
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.0.5.tar.gz"
  sha256 "a9cdaf7334bf28dc71c6338d090c1d1402041c5e320b6c2e3669f7758946a01c"
  revision 1

  bottle do
    sha1 "872925e415e5e3acf4aaf3d0ff6fb9dfad0d0397" => :mavericks
    sha1 "349e86e0f903217ac0e3e457ff46f3b24eea0fd6" => :mountain_lion
    sha1 "054dd40ae4f4007a886a98ade85441eb3be6710f" => :lion
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
