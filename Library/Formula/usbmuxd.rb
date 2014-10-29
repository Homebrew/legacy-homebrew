require "formula"

class Usbmuxd < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libusbmuxd-1.0.9.tar.bz2"
  sha1 "7b05ee971ba277591b76040078df598e3710f6db"

  head "http://cgit.sukimashita.com/usbmuxd.git"

  bottle do
    cellar :any
    revision 1
    sha1 "df155e8fd46fb368a27359dfb1d3e38748e62520" => :yosemite
    sha1 "111014819a0d4351ddb074e917f399a74bcf1442" => :mavericks
    sha1 "f23f5dee72baff05e14f59e0b1adbc52e9d2918d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libplist"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
