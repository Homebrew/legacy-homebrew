require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url "http://hackage.haskell.org/package/cabal-install-1.20.0.1/cabal-install-1.20.0.1.tar.gz"
  sha1 "268eca309381d4de79b7fd5f69b6ca01a0d18030"

  bottle do
    cellar :any
    sha1 "d66564529604739d153641fe7cdd1c43b04387c0" => :mavericks
    sha1 "b4c53ae187560fe4b0d8cb70123230b0ac638ca6" => :mountain_lion
    sha1 "487e8249f3d64ae28264c62c09dbabc9011a21d0" => :lion
  end

  depends_on 'ghc'

  conflicts_with 'haskell-platform'

  def install
    # use a temporary package database instead of ~/.cabal or ~/.ghc
    pkg_db = "#{Dir.pwd}/package.conf.d"
    system 'ghc-pkg', 'init', pkg_db
    ENV['EXTRA_CONFIGURE_OPTS'] = "--package-db=#{pkg_db}"
    ENV['PREFIX'] = Dir.pwd
    inreplace 'bootstrap.sh', 'list --global',
      'list --global --no-user-package-db'

    system 'sh', 'bootstrap.sh'
    bin.install "bin/cabal"
    bash_completion.install 'bash-completion/cabal'
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", 'info', 'cabal'
  end
end
