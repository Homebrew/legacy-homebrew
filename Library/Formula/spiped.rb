require "formula"

class Spiped < Formula
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.4.1.tgz"
  sha256 "0eeb4b8a94df985cfb60f452ced75f30509105a120ca09f740507c496c15c4f8"

  bottle do
    cellar :any
    sha1 "2519a2e5d5d0f34557b7b7d270f73775a2ade6ae" => :mavericks
    sha1 "cd3d98ee01de0e20cbb51cae599a4df44ac9dc67" => :mountain_lion
    sha1 "f8c0616790727cc2650fb69e683ac790194143b4" => :lion
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
