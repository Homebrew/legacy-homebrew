class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.22.6.0/cabal-install-1.22.6.0.tar.gz"
  sha256 "9d239e385696a7faa49f068aea451882baec6a7df26fbddbd08271c9053cb0b4"

  bottle do
    sha256 "07890be8c3dd1cf938117fd9ef33e22dca9602b17d99aa8f2189b0d36ac522e4" => :yosemite
    sha256 "a31402a686055a7107e50b2c952991d7969f8ba1fa77ff97680657772feaece2" => :mavericks
    sha256 "3b88e5bc77f90b3cce16f3b7c0e21ef68117abbb74a022e36e444edf1740709f" => :mountain_lion
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
