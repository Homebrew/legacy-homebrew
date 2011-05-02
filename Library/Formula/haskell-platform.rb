require 'formula'

class HaskellPlatform < Formula
  url 'http://lambda.galois.com/hp-tmp/2011.2.0.1/haskell-platform-2011.2.0.1.tar.gz'
  homepage 'http://hackage.haskell.org/platform/'
  md5 '97fd42f169a426d043368cec342745ef'
  version '2011.2.0.1'

  depends_on 'ghc'

  def install
    # libdir doesn't work if passed to configure, needs to be passed to make install
    system "./configure", "--prefix=#{prefix}"
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
