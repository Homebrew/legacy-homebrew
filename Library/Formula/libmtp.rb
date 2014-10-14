require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.8/libmtp-1.1.8.tar.gz"
  sha1 "6528da141b9f8a04fc97c0b01cf4f3a6142ff64f"

  bottle do
    cellar :any
    sha1 "e3194ce6f1692562c24ce59b4ba81079e1515817" => :mavericks
    sha1 "7a8fd87ec676a4d38fb66e038d62c4313a73a71f" => :mountain_lion
    sha1 "0bd337f0f7d78d65e90c1c385e6d795e847bed96" => :lion
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
