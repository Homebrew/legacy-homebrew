require 'formula'

class DfuUtil < Formula
  url 'http://dfu-util.gnumonks.org/releases/dfu-util-0.4.tar.gz'
  homepage 'http://dfu-util.gnumonks.org/'
  md5 '2cf466fabb881e8598fa02f286d3242c'

  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
