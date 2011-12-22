require 'formula'

class HaskellPlatform < Formula
  url 'http://lambda.haskell.org/platform/download/2011.4.0.0/haskell-platform-2011.4.0.0.tar.gz'
  homepage 'http://hackage.haskell.org/platform/'
  sha256 'aae19e73d6de2a37508aae652ef92fa21c4cf5b678d40ded5c0a8e1e3492e804'

  depends_on 'ghc'

  def install
    # libdir doesn't work if passed to configure, needs to be passed to make install
    system "./configure", "--prefix=#{prefix}", "--enable-unsupported-ghc-version"
    system %Q(EXTRA_CONFIGURE_OPTS="--libdir=#{lib}/ghc" make install)
  end

  def caveats; <<-EOS.undent
    Run `cabal update` to initialize the package list.

    If you are trying to upgrade from a previous version of haskell-platform,
    you may need to delete .conf files from:
      ~/.ghc/i386-darwin-6.12.3/package.conf.d
    that reference the previous version of haskell-platform first!
    EOS
  end
end
