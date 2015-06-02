class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.9/libmtp-1.1.9.tar.gz"
  sha256 "23f1d3c0b54107388bf2824d56415e9e087c980c86e5d179865652c022b6b189"

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
