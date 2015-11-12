class Librtlsdr < Formula
  desc "Use Realtek DVT-T dongles as a cheap SDR"
  homepage "http://sdr.osmocom.org/trac/wiki/rtl-sdr"
  head "git://git.osmocom.org/rtl-sdr.git", :shallow => false
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.3.tar.gz"
  sha256 "98fb5c34ac94d6f2235a0bb41a08f8bed7949e1d1b91ea57a7c1110191ea58de"

  bottle do
    cellar :any
    revision 1
    sha1 "8680ce437b474e7032b29cb74707a83dccd31a94" => :yosemite
    sha1 "c1e932c691bf46a96c254907201dbf00165f33e5" => :mavericks
    sha1 "e9acc1e44e8cf4c6814b1dee47ea226a24a06d9e" => :mountain_lion
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
