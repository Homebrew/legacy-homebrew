class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.5.0.tgz"
  sha256 "b2f74b34fb62fd37d6e2bfc969a209c039b88847e853a49e91768dec625facd7"

  bottle do
    cellar :any
    sha256 "0fa3dad7bbbc0503aecc38921f83e96bc463ce11cdc4e89c2c7a71a4e99d5063" => :yosemite
    sha256 "86fa5b0f80d693a111d20237c19123448883200c41cb4af8e66fb719cf79ea5e" => :mavericks
    sha256 "2c1ef2cb9518b416626802832bf7df2a3b736b83d2bbc767be7fb81b1be2a4de" => :mountain_lion
  end

  depends_on "bsdmake" => :build
  depends_on "openssl"

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
    doc.install "spiped/README" => "README.spiped", "spipe/README" => "README.spipe"
  end
end
