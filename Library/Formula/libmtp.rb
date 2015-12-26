class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "http://libmtp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.10/libmtp-1.1.10.tar.gz"
  sha256 "1eee8d4c052fe29e58a408fedc08a532e28626fa3e232157abd8fca063c90305"

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
