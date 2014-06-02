require "formula"

class CppNetlib < Formula
  homepage "http://cpp-netlib.org"
  url "http://commondatastorage.googleapis.com/cpp-netlib-downloads/0.11.0/cpp-netlib-0.11.0.tar.gz"
  sha1 "1879224d50681b1398eb8ca6f34f49d679f40b34"

  depends_on "cmake" => :build
  depends_on "boost" => "c++11"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

end
