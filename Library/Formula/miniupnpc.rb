require "formula"

class Miniupnpc < Formula
  desc "UpnP IGD client library and daemon"
  homepage "http://miniupnp.tuxfamily.org"
  url "http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-1.9.20150609.tar.gz"
  sha256 "86e6ccec5b660ba6889893d1f3fca21db087c6466b1a90f495a1f87ab1cd1c36"

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
