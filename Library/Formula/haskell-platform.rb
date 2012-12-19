require 'formula'

class HaskellPlatform < Formula
  homepage 'http://hackage.haskell.org/platform/'
  url 'http://lambda.haskell.org/platform/download/2012.4.0.0/haskell-platform-2012.4.0.0.tar.gz'
  sha1 '7976508c50305969f64c721a1d095ae22efff8b7'

  depends_on 'ghc'

  def install
    # libdir doesn't work if passed to configure, needs to be set in the environment
    system "./configure", "--prefix=#{prefix}", "--enable-unsupported-ghc-version"
    ENV['EXTRA_CONFIGURE_OPTS'] = "--libdir=#{lib}/ghc"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Run `cabal update` to initialize the package list.

    If you are replacing a previous version of haskell-platform, you may want
    to unregister packages belonging to the old version. You can find broken
    packages using:
      ghc-pkg check --simple-output
    You can uninstall them using:
      ghc-pkg check --simple-output | xargs -n 1 ghc-pkg unregister --force
    EOS
  end
end
