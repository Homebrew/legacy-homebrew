require 'formula'

class HaskellPlatform < Formula
  url 'http://lambda.haskell.org/platform/download/2012.2.0.0/haskell-platform-2012.2.0.0.tar.gz'
  homepage 'http://hackage.haskell.org/platform/'
  md5 'db09bc4279c0ef9e0beb5462b793413b'

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
