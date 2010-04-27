require 'formula'

class Libusb <Formula
  url 'http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.7/libusb-1.0.7.tar.bz2'
  homepage 'http://www.libusb.org/'
  md5 '31660f3433ba40c57be31b8a7d709a7d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
