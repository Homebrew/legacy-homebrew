class CabalInstall < Formula
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.22.2.0/cabal-install-1.22.2.0.tar.gz"
  sha256 "25bc2ea88f60bd0f19bf40984ea85491461973895480b8633d87f54aa7ae6adb"

  bottle do
    cellar :any
    sha256 "f79146e9d429b7f2c3ad990873eb67de99ec55383cc83d82229f73f44195d90c" => :yosemite
    sha256 "669bc4766916ecf99ceb3c2ab173a6034362654b4869105bbae7ad98f9ff8ff0" => :mavericks
    sha256 "cffdc3a8bec2a51c2a834bb73e0c56412a8cc0d4ecca036a678f497e91a62958" => :mountain_lion
  end

  depends_on "ghc"

  fails_with :clang if MacOS.version < :mavericks # Same as ghc.rb

  def install
    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
