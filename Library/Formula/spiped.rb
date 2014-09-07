require "formula"

class Spiped < Formula
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.4.1.tgz"
  sha256 "0eeb4b8a94df985cfb60f452ced75f30509105a120ca09f740507c496c15c4f8"

  bottle do
    cellar :any
    sha1 "a5c02e5820d9e0257c8f7989e411f225bd7059bd" => :mavericks
    sha1 "bf7b0a89918b04698a793bf503c202a4ef6a883e" => :mountain_lion
    sha1 "36d6b9cbf1d2128321a60ec487fb6f984347502f" => :lion
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
