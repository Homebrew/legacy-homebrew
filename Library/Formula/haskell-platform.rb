require 'formula'

class HaskellPlatform < Formula
  homepage 'http://hackage.haskell.org/platform/'
  url 'http://lambda.haskell.org/platform/download/2013.2.0.0/haskell-platform-2013.2.0.0.tar.gz'
  sha1 '8669bb5add1826c0523fb130c095fb8bf23a30ce'

  depends_on 'ghc'

  conflicts_with 'cabal-install'

  def install
    # libdir doesn't work if passed to configure, needs to be set in the environment
    system "./configure", "--prefix=#{prefix}"
    ENV['EXTRA_CONFIGURE_OPTS'] = "--libdir=#{lib}/ghc"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Initialize the package list by using:
      cabal update
    Packages are installed into ~/.cabal by default. To use executables
    installed via Cabal (including newer versions of cabal-install), prepend
    $HOME/.cabal/bin to your $PATH by adding to your ~/.bash_profile the
    following line:
      export PATH="$HOME/.cabal/bin:$PATH"

    If you are replacing a previous version of haskell-platform, you may want
    to unregister packages belonging to the old version. You can find broken
    packages using:
      ghc-pkg check --simple-output
    You can uninstall them using:
      ghc-pkg check --simple-output | xargs -n 1 ghc-pkg unregister --force
    EOS
  end
end
