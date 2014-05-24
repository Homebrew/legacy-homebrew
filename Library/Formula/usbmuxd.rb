require "formula"

class Usbmuxd < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libusbmuxd-1.0.9.tar.bz2"
  sha1 "7b05ee971ba277591b76040078df598e3710f6db"

  head "http://cgit.sukimashita.com/usbmuxd.git"

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
