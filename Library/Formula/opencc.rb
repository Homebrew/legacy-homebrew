require "formula"

class Opencc < Formula
  homepage "https://github.com/BYVoid/OpenCC"
  url "http://dl.bintray.com/byvoid/opencc/opencc-1.0.2.tar.gz"
  sha1 "101b9f46aca95d2039a955572c394ca6bdb2d88d"

  bottle do
    sha1 "f49556768692c346a700382cec6746ee3d425ff3" => :yosemite
    sha1 "e7024a546b9b322a5cdb43703004a93a5dcd21b9" => :mavericks
    sha1 "535532648a4f756a5c20ddda3da12953c7520128" => :mountain_lion
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
