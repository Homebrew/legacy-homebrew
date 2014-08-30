require "formula"

class Spiped < Formula
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.3.1.tgz"
  sha256 "8a58a983be460b88ed5a105201a0f0afacb83382208761837a62871dcca42fee"

  bottle do
    cellar :any
    sha1 "e4d18a28b907ad3a02199b1c72e9c78fbbcc69ec" => :mavericks
    sha1 "418827b51bda749149b4c0a9fd376f8aba9171d3" => :mountain_lion
    sha1 "1f320a1a68f9871e93bc669f53761601d2183882" => :lion
  end

  depends_on :bsdmake
  depends_on "openssl"

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
    doc.install "spiped/README" => "README.spiped",
                "spipe/README" => "README.spipe"
  end
end
