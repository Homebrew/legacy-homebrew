require "formula"

class Apngasm < Formula
  homepage "https://github.com/apngasm/apngasm"
  url "https://github.com/apngasm/apngasm/archive/3.1.3.tar.gz"
  sha1 "5968640a5610e5ab47ef8464e413e714d2ef64a5"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "lzlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "apngasm", "--version | grep -q 3.1.3"
  end
end
