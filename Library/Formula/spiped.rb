class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.5.0.tgz"
  sha256 "b2f74b34fb62fd37d6e2bfc969a209c039b88847e853a49e91768dec625facd7"

  bottle do
    cellar :any
    sha1 "dc03cb40b160fa0720b228fb54aafaff05425790" => :yosemite
    sha1 "59ec8ccb0d50b8b80e8f6627b6842ab37a73777c" => :mavericks
    sha1 "c971b8d141926434a69eb3ca7141217be10f9ecb" => :mountain_lion
  end

  depends_on "bsdmake" => :build
  depends_on "openssl"

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
    doc.install "spiped/README" => "README.spiped", "spipe/README" => "README.spipe"
  end
end
