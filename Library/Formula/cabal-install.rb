class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.22.6.0/cabal-install-1.22.6.0.tar.gz"
  sha256 "9d239e385696a7faa49f068aea451882baec6a7df26fbddbd08271c9053cb0b4"

  bottle do
    sha256 "038be93dac43c7d28f65b9dade9b8e5fcf249d2d2b27e7c06a31fd79e44de0ed" => :yosemite
    sha256 "e1819fa8d2567adcb369503426a18c6abd610fbadbe72b66128cfa2baabfbacb" => :mavericks
    sha256 "1742ed2dede4863e98dffcfb17d964c9ac07cd09484b64f9955ddec1433acaea" => :mountain_lion
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
