require 'formula'

class Libusb <Formula
  url 'http://downloads.sourceforge.net/project/libusb/libusb-0.1%20%28LEGACY%29/0.1.12/libusb-0.1.12.tar.gz'
  homepage 'http://libusb.sourceforge.net'
  md5 'caf182cbc7565dac0fd72155919672e6'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
