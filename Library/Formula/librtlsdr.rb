require "formula"

class Librtlsdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/rtl-sdr"
  head "git://git.osmocom.org/rtl-sdr.git", :shallow => false
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.3.tar.gz"
  sha1 "f6f20f7b0562a6d3f7b9ff7bff38a15bff175982"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    if build.universal?
      ENV.universal_binary
      ENV["CMAKE_OSX_ARCHITECTURES"] = Hardware::CPU.universal_archs.as_cmake_arch_flags
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
