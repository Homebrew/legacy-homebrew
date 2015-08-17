class Perceptualdiff < Formula
  desc "Perceptual image comparison tool"
  homepage "http://pdiff.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdiff/pdiff/perceptualdiff-1.1.1/perceptualdiff-1.1.1-src.tar.gz"
  sha256 "ab349279a63018663930133b04852bde2f6a373cc175184b615944a10c1c7c6a"

  depends_on "cmake" => :build
  depends_on "freeimage"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
