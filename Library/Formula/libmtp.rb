require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url 'http://sourceforge.net/projects/libmtp/files/libmtp/1.1.6/libmtp-1.1.6.tar.gz'
  sha1 'f9e55c75399fc5f4deabcdfa58e1b01b2e6e3283'

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "libgcrypt" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
