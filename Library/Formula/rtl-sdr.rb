class RtlSdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/rtl-sdr"
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.3.tar.gz"
  sha256 "98fb5c34ac94d6f2235a0bb41a08f8bed7949e1d1b91ea57a7c1110191ea58de"
  head "git://git.osmocom.org/rtl-sdr.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match(
      %r{^rtl_sdr, an I/Q recorder for RTL2832 }m,
      shell_output("#{bin}/rtl_sdr 2>&1", 1)
    )
  end
end
