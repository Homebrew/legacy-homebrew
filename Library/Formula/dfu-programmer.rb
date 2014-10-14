require "formula"

class DfuProgrammer < Formula
  homepage "http://dfu-programmer.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dfu-programmer/dfu-programmer/0.7.0/dfu-programmer-0.7.0.tar.gz"
  sha1 "a8d91053b7ec20185eb87c31f63340474e64b1dd"

  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                           "--disable-libusb_1_0"
    system "make install"
  end
end
