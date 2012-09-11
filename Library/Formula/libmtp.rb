require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libmtp/libmtp/1.1.4/libmtp-1.1.4.tar.gz'
  md5 '27d9bcbc925c1ef84869eb27fdda54e8'

  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
