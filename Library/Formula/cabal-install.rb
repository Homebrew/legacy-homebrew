class CabalInstall < Formula
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.22.2.0/cabal-install-1.22.2.0.tar.gz"
  sha256 "25bc2ea88f60bd0f19bf40984ea85491461973895480b8633d87f54aa7ae6adb"

  bottle do
    sha256 "28be6f29bde3ae58c67acbb6cf8d9f09f035bf2f1f14225242eb050cd4cec405" => :yosemite
    sha256 "c92e20e918f01bc88aace10a6250bf49e36f724354b69b50eb0e7e4c8b826417" => :mavericks
    sha256 "6fe44ef6d3f82bf2010fa2779bea5164962e68626f30f4e6d608f793911bf7ce" => :mountain_lion
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
