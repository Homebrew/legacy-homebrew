require "formula"

class Snappystream < Formula
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/0.1.2.tar.gz"
  sha1 "40ceac66a58659d1827cc7375a72210bb84be9b3"

  head "https://github.com/hoxnox/snappystream.git"

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on "cmake" => :build
  depends_on "snappy"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTS=ON" if build.with? "check"

    system "cmake", ".", *args
    system "make"
    system "make", "test" if build.with? "check"
    system "make", "install"
  end
end
