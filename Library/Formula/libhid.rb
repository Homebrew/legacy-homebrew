require 'formula'

class Libhid < Formula
  url 'http://alioth.debian.org/frs/download.php/1958/libhid-0.2.16.tar.gz'
  homepage 'http://libhid.alioth.debian.org/'
  md5 'f2a427a6d6b98a5db8d17e2777173af7'

  depends_on 'libusb'
  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--disable-swig"

    system "make install"
  end
end
