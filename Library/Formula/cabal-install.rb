class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.22.6.0/cabal-install-1.22.6.0.tar.gz"
  sha256 "9d239e385696a7faa49f068aea451882baec6a7df26fbddbd08271c9053cb0b4"

  bottle do
    revision 1
    sha256 "75a8233c8825ca13afa976fadff8ddda532aa1deeeba1a1bb4d2b227e2dc4e2d" => :el_capitan
    sha256 "5afe2d71b44c28af300384b6f957dbe65b87fb0d7276609016856733f7791bfa" => :yosemite
    sha256 "a328d8c73a3913ef488db38a8ff29162ae863c9b66f1e76b1480c4f23560f9ee" => :mavericks
  end

  depends_on "ghc"

  fails_with :clang if MacOS.version < :lion # Same as ghc.rb

  def install
    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
