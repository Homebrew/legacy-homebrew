require 'formula'

class DfuProgrammer < Formula
  url 'http://sourceforge.net/projects/dfu-programmer/files/dfu-programmer/0.5.5/dfu-programmer-0.5.5.tar.gz'
  homepage 'http://dfu-programmer.sourceforge.net/'
  sha1 '1687690d0d08111d9f65b6b4390058e6fef4710e'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-libusb_1_0",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
