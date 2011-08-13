require 'formula'

class Ghc < Formula
  homepage 'http://haskell.org/ghc/'
  version '7.2.1'
  if Hardware.is_64_bit?
    url 'http://www.haskell.org/ghc/dist/7.2.1/ghc-7.2.1-x86_64-apple-darwin.tar.bz2'
    md5 '314a9ad7fbc4fcafd612e12ab6b45140'
  else
    url 'http://www.haskell.org/ghc/dist/7.2.1/ghc-7.2.1-i386-apple-darwin.tar.bz2'
    md5 'f17c16770969e3c1a516ad0a3cee40a6'
  end

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  def install
    system "./configure --prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only; you might also be interested in haskell-platform or cabal-install.
    EOS
  end
end
