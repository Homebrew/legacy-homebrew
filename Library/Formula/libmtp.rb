require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.8/libmtp-1.1.8.tar.gz"
  sha1 "6528da141b9f8a04fc97c0b01cf4f3a6142ff64f"

  bottle do
    cellar :any
    revision 1
    sha1 "efc495ff51c145e3ba7fc788e7381a9b0c75fb37" => :yosemite
    sha1 "ad318f5a47cbbc64e17bcd5955c11aaeaa03163e" => :mavericks
    sha1 "9e40ef6dc2e2068ea3bb73fb7e3d901ee58b470d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make install"
  end
end
