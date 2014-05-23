require "formula"

class CppNetlib < Formula
  homepage "http://cpp-netlib.org"
  url "http://commondatastorage.googleapis.com/cpp-netlib-downloads/0.11.0/cpp-netlib-0.11.0.tar.gz"
  sha1 "1879224d50681b1398eb8ca6f34f49d679f40b34"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCMAKE_C_COMPILER=clang", "-DCMAKE_CXX_COMPILER=clang++", *std_cmake_args
    system "make"
    system "make", "install"
  end

end
