require 'formula'

class DfuProgrammer < Formula
  url 'http://sourceforge.net/projects/dfu-programmer/files/dfu-programmer/0.5.4/dfu-programmer-0.5.4.tar.gz'
  homepage 'http://dfu-programmer.sourceforge.net/'
  md5 '707dcd0f957a74e92456ea6919faa772'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
