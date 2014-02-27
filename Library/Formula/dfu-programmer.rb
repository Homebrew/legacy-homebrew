require 'formula'

class DfuProgrammer < Formula
  homepage 'http://dfu-programmer.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/dfu-programmer/dfu-programmer/0.6.2/dfu-programmer-0.6.2.tar.gz'
  sha1 '3a7d7b3770b85030a5b84ac73f1c06efca99a591'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                           "--disable-libusb_1_0"
    system "make install"
  end
end
