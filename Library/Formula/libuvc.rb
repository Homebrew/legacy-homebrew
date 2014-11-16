require "formula"

class Libuvc < Formula
  homepage "https://github.com/ktossell/libuvc"
  url "https://github.com/ktossell/libuvc/archive/v0.0.5.tar.gz"
  sha1 "ab2e06d014af6aa72238113666f57405f45d1d18"

  head "https://github.com/ktossell/libuvc.git"

  bottle do
    revision 1
    sha1 "600fa35a693bccc80b44f731acc9cd945c35181d" => :yosemite
    sha1 "b292f190f52e1e659aa3c2e51c19f15b421fb01e" => :mavericks
    sha1 "6216c3b15fc83f9612b8573999d0dc537381a20b" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libusb"
  depends_on "jpeg" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
