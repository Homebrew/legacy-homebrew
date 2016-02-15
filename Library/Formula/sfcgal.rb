class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.2.2.tar.gz"
  sha256 "dae7de4c7e1b4ef2a51c55f7d201a6d8049b518caac14f4033fd2d43f14eb031"

  bottle do
    sha256 "cddb259f1fdc03ba213c56757485efee012acf10c96f39af7387ee40b4901f8e" => :el_capitan
    sha256 "65c06ed4853d2179793da87bebd78c3b025cb8b2437e41dd40f247f9a322a656" => :yosemite
    sha256 "6512802b7da2f59d1a449dda91d15537be24814bee913ca73c68ccd7082f1d9e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
