class Rtl433 < Formula
  desc "Tool to talk to 433Mhz devices using RTL devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433/archive/0.01.tar.gz"
  sha256 "10f29c0ea91684f91f42537cf2498b1236411ab2c48893f2d139126ad4e000e5"
  head "https://github.com/merbanan/rtl_433.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"  => :build
  depends_on "librtlsdr"

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/rtl_433", "-h"
  end
end
