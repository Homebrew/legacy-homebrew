require "formula"

class CabalInstall < Formula
  homepage "https://www.haskell.org/cabal/"
  url "http://hackage.haskell.org/package/cabal-install-1.20.0.6/cabal-install-1.20.0.6.tar.gz"
  sha1 "f28fa64199247e2640ca66b4b3441dd818a98210"
  revision 1

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
    # use a temporary package database instead of ~/.cabal or ~/.ghc
    pkg_db = "#{Dir.pwd}/package.conf.d"
    system "ghc-pkg", "init", pkg_db
    ENV["EXTRA_CONFIGURE_OPTS"] = "--package-db=#{pkg_db}"
    ENV["PREFIX"] = Dir.pwd
    inreplace "bootstrap.sh", "list --global",
      "list --global --no-user-package-db"

    system "sh", "bootstrap.sh"
    bin.install "bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
