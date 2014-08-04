require "formula"

class Libuvc < Formula
  homepage "https://github.com/ktossell/libuvc"
  url "https://github.com/ktossell/libuvc/archive/v0.0.5.tar.gz"
  sha1 "ab2e06d014af6aa72238113666f57405f45d1d18"

  head "https://github.com/ktossell/libuvc.git"

  bottle do
    sha1 "592b2190a35ab15f07c25d39f3e34a0baae971e2" => :mavericks
    sha1 "c13fafbeab7ebc19565be18423bb34248c9557a6" => :mountain_lion
    sha1 "82645fb85228750be0aba5d2fd2b10bbc9ed888c" => :lion
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
