require "formula"

class Dcled < Formula
  homepage "http://www.jeffrika.com/~malakai/dcled/index.html"
  url "http://www.jeffrika.com/~malakai/dcled/dcled-2.2.tgz"
  sha1 "7cc984d894a5d6a27a4a1e5b86444d85d2e1b565"

  depends_on "libhid"
  depends_on "libusb"

  def install
    system "make", "CC=#{ENV.cc}",
                   "LIBUSB_CFLAGS=-I#{Formula["libusb"].opt_include}/libusb-1.0"
    system "make", "install",
                   "FONTDIR=#{share}/#{name}",
                   "INSTALLDIR=#{bin}"
  end
end
