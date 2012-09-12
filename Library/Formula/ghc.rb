require 'formula'

class NeedsSnowLeopard < Requirement
  def satisfied?
    MacOS.version >= :snow_leopard
  end

  def message; <<-EOS.undent
    GHC requires OS X 10.6 or newer. The binary releases no longer work on
    Leopard. See the following issue for details:
        http://hackage.haskell.org/trac/ghc/ticket/6009
    EOS
  end
end

class Ghc < Formula
  homepage 'http://haskell.org/ghc/'
  version '7.6.1'
  if Hardware.is_64_bit? and not build.build_32_bit?
    url 'http://www.haskell.org/ghc/dist/7.6.1/ghc-7.6.1-x86_64-apple-darwin.tar.bz2'
    sha1 'd6d150ec50c4a93e6b52014c4731239ab4c32fa2'
  else
    url 'http://www.haskell.org/ghc/dist/7.6.1/ghc-7.6.1-i386-apple-darwin.tar.bz2'
    sha1 'aaee29f905584b38f64a1e2cc9a5211ad73f63a8'
  end

  depends_on NeedsSnowLeopard.new

  option '32-bit'

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Building with Clang configures GHC to use Clang as its preprocessor,
      which causes subsequent GHC-based builds to fail.
      EOS
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only; you might also be interested in haskell-platform.
    EOS
  end
end
