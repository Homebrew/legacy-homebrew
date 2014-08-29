require "formula"

class Librtlsdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/rtl-sdr"
  head "git://git.osmocom.org/rtl-sdr.git", :shallow => false
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.3.tar.gz"
  sha1 "f6f20f7b0562a6d3f7b9ff7bff38a15bff175982"

  bottle do
    cellar :any
    sha1 "8bc76582e3464d4fa380e2fb3bf91d71a697b1b2" => :mavericks
    sha1 "aafd6ee6cfe60cfc5d9ff9c4ed76893bf71873eb" => :mountain_lion
    sha1 "24a67d577ad05261285acc8cfb03cb2a34afabfa" => :lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make install"
    end
  end
end
