require "formula"

class Usbmuxd < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libusbmuxd-1.0.10.tar.bz2"
  sha1 "9d4ce8ac058cfea66e6785d2bad5bb9c93681b16"

  bottle do
    cellar :any
    sha1 "df155e8fd46fb368a27359dfb1d3e38748e62520" => :yosemite
    sha1 "111014819a0d4351ddb074e917f399a74bcf1442" => :mavericks
    sha1 "f23f5dee72baff05e14f59e0b1adbc52e9d2918d" => :mountain_lion
  end

  head do
    url "http://git.sukimashita.com/libusbmuxd.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libplist"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
