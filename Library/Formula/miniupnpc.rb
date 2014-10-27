require "formula"

class Miniupnpc < Formula
  homepage "http://miniupnp.tuxfamily.org"
  url "http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-1.9.20141027.tar.gz"
  sha1 "b3c8e7f1e8d0a43ee274866730347e9871903ea1"

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
