require 'formula'

class Libusb <Formula
  url 'http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.6/libusb-1.0.6.tar.bz2'
  homepage 'http://libusb.sourceforge.net'
  md5 '818c7c02112a53e0c182666ee83f2057'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
