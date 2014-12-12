require "formula"

class Opencc < Formula
  homepage "https://github.com/BYVoid/OpenCC"
  url "http://dl.bintray.com/byvoid/opencc/opencc-1.0.2.tar.gz"
  sha1 "101b9f46aca95d2039a955572c394ca6bdb2d88d"

  bottle do
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_DOCUMENTATION:BOOL=OFF", *std_cmake_args
    system "make"
    system "make install"
  end
end
