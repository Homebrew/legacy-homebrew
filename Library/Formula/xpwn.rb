class Xpwn < Formula
  homepage "https://github.com/planetbeing/xpwn"
  url "https://github.com/planetbeing/xpwn.git"
  sha256 "6c3c00ee92275c0498a52f3e2912add8d84e693acc3edf88e8febaadc8283d61"
  version "1.0"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "libpng"
  depends_on "libusb"
  depends_on "lzlib"

  def install
    system "cmake", "."
    system "make"
    bin.install "dmg/dmg"
    bin.install "dripwn/dripwn"
    bin.install "hdutil/hdutil"
    bin.install "hfs/hfsplus"
    bin.install "ipsw-patch/ipsw"
    bin.install "ipsw-patch/xpwntool"
  end

  test do
    system "#{bin}/dmg"
    system "#{bin}/dripwn"
    system "#{bin}/hdutil"
    system "#{bin}/hfsplus"
    system "#{bin}/ipsw"
    system "#{bin}/xpwntool"
  end
end
