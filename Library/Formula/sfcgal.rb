require "formula"

class Sfcgal < Formula
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.0.5.tar.gz"
  sha256 "a9cdaf7334bf28dc71c6338d090c1d1402041c5e320b6c2e3669f7758946a01c"
  revision 1

  bottle do
    sha1 "a0aecc3d53ba2b343ea0a62a50d0d3bbe1de85f9" => :mavericks
    sha1 "0e34b4fad960a095b4009754c18860ac515eb486" => :mountain_lion
    sha1 "e74e8ddb2eafa1a884663a1784bca8734d7ee438" => :lion
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
