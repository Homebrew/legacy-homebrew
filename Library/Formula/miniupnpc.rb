require "formula"

class Miniupnpc < Formula
  homepage "http://miniupnp.tuxfamily.org"
  url "http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-1.9.20141027.tar.gz"
  sha1 "b3c8e7f1e8d0a43ee274866730347e9871903ea1"

  bottle do
    cellar :any
    sha1 "ee9cb081a8ebfda57d568bf7df403703a0b89ef9" => :yosemite
    sha1 "97d743dbcbd8833d42abc7ed497ce7b86711cffd" => :mavericks
    sha1 "3eef46a3903bd91d8e1443ac91ce53daa46f0326" => :mountain_lion
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
