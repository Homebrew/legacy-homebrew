require "formula"

class CabalInstall < Formula
  homepage "http://www.haskell.org/haskellwiki/Cabal-Install"
  url "http://hackage.haskell.org/package/cabal-install-1.20.0.3/cabal-install-1.20.0.3.tar.gz"
  sha1 "444448b0f704420e329e8fc1989b6743c1c8546d"
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

    # Avoid a nasty bug in Cabal by forcing the bootstrap script to pull a later version.
    # (q.v. https://github.com/haskell/cabal/issues/1740)
    inreplace "bootstrap.sh", 'CABAL_VER="1.20.0.0";', 'CABAL_VER="1.20.0.2";'

    system "sh", "bootstrap.sh"
    bin.install "bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
