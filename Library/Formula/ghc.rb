require 'formula'

class NeedsSnowLeopard < Requirement
  satisfy MacOS.version >= :snow_leopard

  def message; <<-EOS.undent
    GHC requires OS X 10.6 or newer. The binary releases no longer work on
    Leopard. See the following issue for details:
        http://hackage.haskell.org/trac/ghc/ticket/6009
    EOS
  end
end

class Ghc < Formula
  homepage 'http://haskell.org/ghc/'
  if Hardware.is_64_bit? and not build.build_32_bit?
    url 'http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-apple-darwin.tar.bz2'
    sha1 'fb9f18197852181a9472221e1944081985b75992'
  else
    url 'http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-i386-apple-darwin.tar.bz2'
    sha1 '6a312263fef41e06003f0676b879f2d2d5a1f30c'
  end
  version '7.6.3'

  depends_on NeedsSnowLeopard

  option '32-bit'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      Building with Clang configures GHC to use Clang as its preprocessor,
      which causes subsequent GHC-based builds to fail.
      EOS
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-gcc=#{ENV.cc}"
    ENV.j1 # Fixes an intermittent race condition
    system 'make', 'install'
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only.

    You might also be interested in cabal-install to get Cabal, Haskell's
    package manager, or haskell-platform to get Cabal and some widely-used
    packages all in one go.
    EOS
  end
end
