require 'formula'

class Libhid < Formula
  homepage 'http://libhid.alioth.debian.org/'
  url 'http://alioth.debian.org/frs/download.php/1958/libhid-0.2.16.tar.gz'
  sha1 '9a25fef674e8f20f97fea6700eb91c21ebbbcc02'

  depends_on 'libusb'
  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-swig"

    system "make install"
  end
end
