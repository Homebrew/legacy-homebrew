require 'formula'

class Libmtp < Formula
  url 'http://downloads.sourceforge.net/project/libmtp/libmtp/1.0.1/libmtp-1.0.1.tar.gz'
  homepage 'http://libmtp.sourceforge.net/'
  md5 'd540a0ef033483bd10b7f83f7a84e4a7'

  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
