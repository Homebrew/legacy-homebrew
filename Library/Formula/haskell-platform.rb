require 'formula'

class HaskellPlatform < Formula
  url 'http://lambda.haskell.org/platform/download/2011.4.0.0/haskell-platform-2011.4.0.0.tar.gz'
  homepage 'http://hackage.haskell.org/platform/'
  sha1 '0dc3abd2f046f4437b7ea0bf1588175f16cd439b'

  depends_on 'ghc'

  def install
    # libdir doesn't work if passed to configure, needs to be passed to make install
    system "./configure", "--prefix=#{prefix}", "--enable-unsupported-ghc-version"
    system %Q(EXTRA_CONFIGURE_OPTS="--libdir=#{lib}/ghc" make install)
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
