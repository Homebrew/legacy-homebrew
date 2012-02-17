require 'formula'

class Libmtp < Formula
  url 'http://downloads.sourceforge.net/project/libmtp/libmtp/1.1.2/libmtp-1.1.2.tar.gz'
  homepage 'http://libmtp.sourceforge.net/'
  md5 '6dc708757e3fd3ccce7445b4f2171263'

  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
