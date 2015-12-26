class Librtlsdr < Formula
  desc "Use Realtek DVT-T dongles as a cheap SDR"
  homepage "http://sdr.osmocom.org/trac/wiki/rtl-sdr"
  head "git://git.osmocom.org/rtl-sdr.git", :shallow => false
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.3.tar.gz"
  sha256 "98fb5c34ac94d6f2235a0bb41a08f8bed7949e1d1b91ea57a7c1110191ea58de"

  bottle do
    cellar :any
    revision 1
    sha256 "d9e6bf3b47b6600d9fb3251cdcb0c7d89dcb9d292609453808303944df2f8981" => :yosemite
    sha256 "3c7027468e4ae312373a62d166a2860be9e27711663fb5f0e52b6e3a3ddc5c6d" => :mavericks
    sha256 "1d6986e78140d3135492e087356435b19647f090d902b334b400315bc8baebd5" => :mountain_lion
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
      system "make", "install"
    end
  end
end
