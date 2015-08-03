class Dcled < Formula
  desc "Linux driver for dream cheeky USB message board"
  homepage "http://www.jeffrika.com/~malakai/dcled/index.html"
  url "http://www.jeffrika.com/~malakai/dcled/dcled-2.2.tgz"
  sha256 "0da78c04e1aa42d16fa3df985cf54b0fbadf2d8ff338b9bf59bfe103c2a959c6"

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
