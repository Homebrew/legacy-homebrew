require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libmtp/libmtp/1.1.2/libmtp-1.1.2.tar.gz'
  sha1 '239c07afcb1ebd02b865050d0a31f5ff36b012d5'

  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
