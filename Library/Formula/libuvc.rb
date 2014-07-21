require "formula"

class Libuvc < Formula
  homepage "https://github.com/ktossell/libuvc"
  url "https://github.com/ktossell/libuvc/archive/v0.0.5.tar.gz"
  sha1 "ab2e06d014af6aa72238113666f57405f45d1d18"

  bottle do
    sha1 "36d644135909d262346f434be9b470f7be13c149" => :mavericks
    sha1 "fccfef69b9b81ad405afc3d10916a8984266545d" => :mountain_lion
    sha1 "3f5104157aa2c1ba31a549b3382119b5c2d0327b" => :lion
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
