require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libmtp/libmtp/1.1.2/libmtp-1.1.2.tar.gz'
  md5 '6dc708757e3fd3ccce7445b4f2171263'

  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
