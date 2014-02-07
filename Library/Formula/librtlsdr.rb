require "formula"

class Librtlsdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/rtl-sdr"
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.3.tar.gz"
  sha1 "f6f20f7b0562a6d3f7b9ff7bff38a15bff175982"

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
