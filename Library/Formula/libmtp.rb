require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.6/libmtp-1.1.6.tar.gz'
  sha1 'f9e55c75399fc5f4deabcdfa58e1b01b2e6e3283'

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make install"
  end
end
