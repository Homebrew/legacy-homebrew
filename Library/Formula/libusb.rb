require 'formula'

class Libusb <Formula
  url 'http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.8/libusb-1.0.8.tar.bz2'
  homepage 'http://www.libusb.org/'
  md5 '37d34e6eaa69a4b645a19ff4ca63ceef'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
