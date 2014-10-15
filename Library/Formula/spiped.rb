require "formula"

class Spiped < Formula
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.4.2.tgz"
  sha256 "dcb668f98a6bd761ff542f7079034f828f792259300eeb16aab53b687a805bde"

  bottle do
    cellar :any
    sha1 "66d1c75b789043dad26a0615276a3cf447394c3d" => :mavericks
    sha1 "2d57e00a7bd6e275bf0366c67d8b727818165c43" => :mountain_lion
    sha1 "d947a62a7f03ea5c608b6ec43c9c5ed0333f4a06" => :lion
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
