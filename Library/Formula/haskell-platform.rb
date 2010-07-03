require 'formula'

class HaskellPlatform <Formula
  url 'http://hackage.haskell.org/platform/2010.1.0.0/haskell-platform-2010.1.0.0.tar.gz'
  homepage 'http://hackage.haskell.org/platform/'
  md5 'ad96a12535b955f2f5e11769b02e0f76'
  version '2010.1.0.0'

  depends_on 'ghc'

  def install
    # haskell-platform expects 6.12.1 but we have 6.12.3, so force the issue.
    # libdir doesn't work if passed to configure, needs to be passed to make install
    system "./configure", "--prefix=#{prefix}", "--enable-unsupported-ghc-version"
    system %Q(EXTRA_CONFIGURE_OPTS="--libdir=#{lib}/ghc" make install)
  end

  def caveats
    "Run `cabal update` to initialize the package list."
  end
end
