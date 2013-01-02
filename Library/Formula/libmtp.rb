require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url 'http://sourceforge.net/projects/libmtp/files/libmtp/1.1.4/libmtp-1.1.4.tar.gz'
  sha1 '07f6b64e4d3c4966fab8d6d507d90eb2e6dff538'

  depends_on "libusb-compat"
  depends_on "libgcrypt" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
