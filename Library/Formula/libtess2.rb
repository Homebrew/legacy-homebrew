require 'formula'


class Libtess2 < Formula
  homepage 'https://code.google.com/p/libtess2/'
  url 'https://libtess2.googlecode.com/files/libtess2-1.0.zip'
  sha1 '53e968add78711c3eb5cdc0948d85c9bd1db2751'

  depends_on 'cmake' => :build

  def install
    File.open("CMakeLists.txt","w") do |f|
        f.puts "cmake_minimum_required(VERSION 2.6)\n"
        f.puts "project(libtess)\n"
        f.puts "file(GLOB SRCS \"Source/*.cpp\" \"Source/*.c\" \"Source/*.h\" \"Source/*.hpp\")\n"
        f.puts "include_directories(\"Include\")\n"
        f.puts "add_library(tess2 ${SRCS} ${SRCS_INCL})\n"
    end

    system "cmake", ".", *std_cmake_args
    system "make" # if this fails, try separate make/make install steps
    lib.install "libtess2.a"
    include.install "Include/tesselator.h"
  end

end
