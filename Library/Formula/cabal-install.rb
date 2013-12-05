require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url 'http://hackage.haskell.org/package/cabal-install-1.18.0.2/cabal-install-1.18.0.2.tar.gz'
  sha1 '2d1f7a48d17b1e02a1e67584a889b2ff4176a773'

  bottle do
    cellar :any
    revision 1
    sha1 'f155f9353d3b76ca63213cfe9e49fa6a9bae9b02' => :mavericks
    sha1 'd2564690f06cbba7e81a5555656383bc457ce6d5' => :mountain_lion
    sha1 '23905bb5789f079fcfe10f4b889d1b8d9c792ef9' => :lion
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
