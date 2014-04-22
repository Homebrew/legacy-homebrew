require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url 'http://hackage.haskell.org/package/cabal-install-1.20.0.0/cabal-install-1.20.0.0.tar.gz'
  sha1 '87eb4efe541475956a23e712d2aeb1c603f1d418'

  bottle do
    cellar :any
    sha1 "ca80a2dd9e033c3c46f3a334fb851e9754e8e294" => :mavericks
    sha1 "354257f5a6e0c79bd5c30dca7cd929965f1e3f43" => :mountain_lion
    sha1 "27186c612aa426a3d8077a09a2be5ccab688f355" => :lion
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
