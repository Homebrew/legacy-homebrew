require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url 'http://hackage.haskell.org/packages/archive/cabal-install/1.18.0.1/cabal-install-1.18.0.1.tar.gz'
  sha1 'ac403d580bd399d682e5d8f4fd8d6d07c03622d9'

  depends_on 'ghc'

  conflicts_with 'haskell-platform'

  def patches
    # force bootstrap.sh to ignore the user package db under ~/.ghc
    DATA
  end

  def install
    # create a temporary package database
    pkg_db = "#{Dir.getwd}/package.conf.d"
    system 'ghc-pkg', 'init', pkg_db

    # use our temporary package database instead of ~/.cabal or ~/.ghc
    ENV['EXTRA_CONFIGURE_OPTS'] = "--package-db=#{pkg_db}"
    ENV['PREFIX'] = Dir.getwd

    # download, compile, and temporarily install cabal-install dependencies
    system 'sh', 'bootstrap.sh'

    # keep the cabal binary and bash completion; trash the rest
    bin.install "bin/cabal"
    bash_completion.install 'bash-completion/cabal'
  end
end

__END__
diff --git a/bootstrap.sh b/bootstrap.sh
index e6eb479..69315b4 100755
--- a/bootstrap.sh
+++ b/bootstrap.sh
@@ -86,7 +86,7 @@ GHC_PKG_VER=`${GHC_PKG} --version | cut -d' ' -f 5`
 
 # Cache the list of packages:
 echo "Checking installed packages for ghc-${GHC_VER}..."
-${GHC_PKG} list --global ${SCOPE_OF_INSTALLATION} > ghc-pkg.list \
+${GHC_PKG} list --global ${SCOPE_OF_INSTALLATION} --no-user-package-db > ghc-pkg.list \
   || die "running '${GHC_PKG} list' failed"
 
 # Will we need to install this package, or is a suitable version installed?

