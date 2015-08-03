class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "http://libmtp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.9/libmtp-1.1.9.tar.gz"
  sha256 "23f1d3c0b54107388bf2824d56415e9e087c980c86e5d179865652c022b6b189"

  bottle do
    cellar :any
    sha256 "be5a361ac01b6aaa620c48525bff8de6a2f8e46c11b190c6b307de57dd02c03e" => :yosemite
    sha256 "620dd6cbd96f7e5287c9c6c2e651a69b303e100f0ebab309267fd4686fdd7d7a" => :mavericks
    sha256 "7f92dfe69e7732ea5e1e583aae5a259b11302020cfb519372d2d5488662bff1f" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make", "install"
  end
end
