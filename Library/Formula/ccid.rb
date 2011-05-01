require 'formula'

class Ccid <Formula
  url 'http://alioth.debian.org/frs/download.php/3475/ccid-1.4.1.tar.bz2'
  homepage 'http://pcsclite.alioth.debian.org/ccid.html'
  md5 'fef5f950dc35202df2fed832498986b9'

  depends_on 'libusb'

  def install
    system "./MacOSX/configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-usbdropdir=#{prefix}/SmartCardServices/drivers"
    system "make install"
  end
end
