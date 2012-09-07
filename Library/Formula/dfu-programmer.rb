require 'formula'

class DfuProgrammer < Formula
  url 'http://sourceforge.net/projects/dfu-programmer/files/dfu-programmer/0.5.4/dfu-programmer-0.5.4.tar.gz'
  homepage 'http://dfu-programmer.sourceforge.net/'
  sha1 'f0fcc8faa0f11e53feaa36a01307328a0b0993d3'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
