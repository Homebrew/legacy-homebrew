require 'formula'

class DfuProgrammer < Formula
  homepage 'http://dfu-programmer.sourceforge.net/'
  url 'http://sourceforge.net/projects/dfu-programmer/files/dfu-programmer/0.6.1/dfu-programmer-0.6.1.tar.gz'
  sha1 'dbbf81a7fd47df7b214358e46e422b6215ae53f0'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                           "--disable-libusb_1_0"
    system "make install"
  end
end
