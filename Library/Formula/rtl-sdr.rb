require 'formula'

class RtlSdr < Formula
  head 'git://git.osmocom.org/rtl-sdr.git'
  homepage 'http://sdr.osmocom.org/trac/wiki/rtl-sdr'
  depends_on 'libusb'

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
