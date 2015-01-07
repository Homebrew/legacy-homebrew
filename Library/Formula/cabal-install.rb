require "formula"

class CabalInstall < Formula
  homepage "http://www.haskell.org/haskellwiki/Cabal-Install"
  url "https://www.haskell.org/cabal/release/cabal-install-1.22.0.0/cabal-install-1.22.0.0.tar.gz"
  sha1 "a4b31edecc80e244231ebc4dc04c109776505ce2"

  bottle do
    cellar :any
    revision 1
    sha1 "2e7eeaf5fa142dee42443e41e08774c6bb80df09" => :yosemite
    sha1 "8a01264adc397dd6057cbfa1db4c709ecf9ce601" => :mavericks
    sha1 "a5516ab7cfe110c0528da484a57124b8805f8ffd" => :mountain_lion
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
