class CabalInstall < Formula
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.22.0.1/cabal-install-1.22.0.1.tar.gz"
  sha256 "87afa8f5d2bffafeffa9ff71062bf09469aade3ae52975c09c35ce61520d10c8"

  bottle do
    cellar :any
    sha1 "29b12fb72f49990c68e8a6507ac22f6ea71e69ec" => :yosemite
    sha1 "8ff0f8981b11799f9c91e81a7a5cde23993bdc79" => :mavericks
    sha1 "905f9d75714667e86197571eabf1b434fbba567d" => :mountain_lion
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
