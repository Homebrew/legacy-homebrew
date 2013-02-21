require 'formula'

class DfuProgrammer < Formula
  homepage 'http://dfu-programmer.sourceforge.net/'
  url 'http://sourceforge.net/projects/dfu-programmer/files/dfu-programmer/0.6.0/dfu-programmer-0.6.0.tar.gz'
  sha1 'db6366f7a00c6d4555f9144e0efc83a799c1e4cc'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                           "--disable-libusb_1_0"
    system "make install"
  end
end
