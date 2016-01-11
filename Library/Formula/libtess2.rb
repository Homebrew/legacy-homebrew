class Libtess2 < Formula
  desc "Refactored version of GLU tesselator"
  homepage "https://code.google.com/p/libtess2/"
  url "https://libtess2.googlecode.com/files/libtess2-1.0.zip"
  sha256 "1938805e1859cbc4459797920743def39fd04154fe60da2ee3ee2198143b96bb"

  bottle do
    cellar :any
    revision 1
    sha256 "925affe887bcd5388e30e116a7f91da95b3149f4fb2a17ee149f0abf00cbddc9" => :yosemite
    sha256 "fa438ed6e594c08dc226ca93ecc56d4f164f11576328dabcffdd3539a971ffd6" => :mavericks
    sha256 "04ffb8fe1e64575384adb1066c3b0556f75be08e65a194b93b0a1a6f8972fa13" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    # creating CMakeLists.txt, since the original source doesn't have one
    (buildpath/"CMakeLists.txt").write <<-EOS.undent
      cmake_minimum_required(VERSION 2.6)
      project(libtess)
      file(GLOB SRCS "Source/*.cpp" "Source/*.c" "Source/*.h" "Source/*.hpp")
      include_directories("Include")
      add_library(tess2 ${SRCS} ${SRCS_INCL})
    EOS

    system "cmake", ".", *std_cmake_args
    system "make"
    lib.install "libtess2.a"
    include.install "Include/tesselator.h"
  end
end
