require 'formula'

class Libtess2 < Formula
  homepage 'https://code.google.com/p/libtess2/'
  url 'https://libtess2.googlecode.com/files/libtess2-1.0.zip'
  sha1 '53e968add78711c3eb5cdc0948d85c9bd1db2751'

  bottle do
    cellar :any
    sha1 "4a0b66321fba525d5e17b84c4978059cc79e89d7" => :mavericks
    sha1 "bc707bcd3debc10404477fb912793fc200b232dc" => :mountain_lion
    sha1 "65aef6feb5da2895198f893f727ecaff6a6af5f2" => :lion
  end

  depends_on 'cmake' => :build

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
