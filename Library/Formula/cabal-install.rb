require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url 'http://hackage.haskell.org/package/cabal-install-1.18.0.3/cabal-install-1.18.0.3.tar.gz'
  sha1 '3cf1672558b037f53f0783c9dab2f8ade9bd99ac'

  bottle do
    cellar :any
    sha1 "11f2d13b46dfefd8b3a237a921084449682b788e" => :mavericks
    sha1 "d4b7dd4842b722926abc12b8730f31751763fa1c" => :mountain_lion
    sha1 "f00f1ffdec0fa722f9aa3a363ac98a1462b4dad4" => :lion
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
