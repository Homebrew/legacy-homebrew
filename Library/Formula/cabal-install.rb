require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url "http://hackage.haskell.org/package/cabal-install-1.20.0.2/cabal-install-1.20.0.2.tar.gz"
  sha1 "e9b3843270b8f5969a4e1205263e59439bc35692"

  bottle do
    cellar :any
    sha1 "cb2da5b5994de0bb2bb31db8245092db7e316cbc" => :mavericks
    sha1 "186eedfdfb31ca7d5eca4f9258820db3b4412aa8" => :mountain_lion
    sha1 "14c4103eac763e6e7b2ee480b1daf739c61ad308" => :lion
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
