require "formula"

class CabalInstall < Formula
  homepage "http://www.haskell.org/haskellwiki/Cabal-Install"
  url "http://hackage.haskell.org/package/cabal-install-1.20.0.3/cabal-install-1.20.0.3.tar.gz"
  sha1 "444448b0f704420e329e8fc1989b6743c1c8546d"

  bottle do
    cellar :any
    sha1 "2802d8bb130b23ab12cc8332531226e80c73e0af" => :mavericks
    sha1 "42ef05cede2a2927ba4a90574c2a0a3aaf84389b" => :mountain_lion
    sha1 "29d6f086d2fdb784634471419a4d0d7db18e477e" => :lion
  end

  depends_on "ghc"

  conflicts_with "haskell-platform"

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
