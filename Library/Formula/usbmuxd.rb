require "formula"

class Usbmuxd < Formula
  homepage "http://www.libimobiledevice.org"
  url "http://www.libimobiledevice.org/downloads/libusbmuxd-1.0.10.tar.bz2"
  sha1 "9d4ce8ac058cfea66e6785d2bad5bb9c93681b16"

  bottle do
    cellar :any
    sha1 "8842576a4da2ec84045888cc50e4df8672798947" => :yosemite
    sha1 "af8be14dba7a0cfd89c0a0a63e2b5f18891cec5a" => :mavericks
    sha1 "8d3728b0c4a52433937cc7d93e21a75e978025d7" => :mountain_lion
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
