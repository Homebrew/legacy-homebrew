# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"

  bottle do
    cellar :any
    sha256 "6cb942b57a00f038100af861b4e835a79dae305c13aee550be21b71c4dfc48ed" => :el_capitan
    sha256 "3b240bf5f3bb91aa3a61d91827573f902da6ba57ca4a0d026e54a789453ac2d7" => :yosemite
    sha256 "de922636432ee49070e8b5208c095d9c0390781db38c887f77f8b657f4a94e14" => :mavericks
    sha256 "8508d1f8e6b92dac8418fc881bd3009419a53a7ac15a685ba4eb9e6b7be9e532" => :mountain_lion
  end

  keg_only :provided_until_xcode43

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
  end
end
