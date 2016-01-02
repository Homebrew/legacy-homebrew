class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/1.6.tar.gz"
  sha256 "92f45cfb26acf51e86c37f00a00292f7ac78cc4abe8cf094c3eb176d7e7c603d"

  bottle do
    cellar :any
    sha256 "ad0cb097b702ac15618c4b6ad81b0d02d350013ca365229c8c0cc7260a308402" => :el_capitan
    sha256 "b9ac8ff4b0c66a04d58b2296b1dec143e5a4805886455d38a9efed43e1a5e506" => :yosemite
    sha256 "ec74a95576867e353ef224a3423282b67a07d05679cb267c4aa368992e547c49" => :mavericks
  end

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "libimobiledevice"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
