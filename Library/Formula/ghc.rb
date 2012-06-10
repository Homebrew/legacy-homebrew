require 'formula'

class NeedsSnowLeopard < Requirement
  def satisfied?
    MacOS.snow_leopard?
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
  version '7.4.1'
  if Hardware.is_64_bit? and not ARGV.build_32_bit?
    url 'http://www.haskell.org/ghc/dist/7.4.1/ghc-7.4.1-x86_64-apple-darwin.tar.bz2'
    sha1 '1acdb6aba3172b28cea55037e58edb2aff4b656d'
  else
    url 'http://www.haskell.org/ghc/dist/7.4.1/ghc-7.4.1-i386-apple-darwin.tar.bz2'
    sha1 '9d96a85b8ca7113a40d0d702d0822bf822d718bb'
  end

  depends_on NeedsSnowLeopard.new

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      Building with Clang configures GHC to use Clang as its preprocessor,
      which causes subsequent GHC-based builds to fail.
      EOS
  end

  def options
    [['--32-bit', 'Build 32-bit only.']]
  end

  def install
    if ARGV.build_devel?
      opoo "The current version of haskell-platform will NOT work with this version of GHC!"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only; you might also be interested in haskell-platform.
    EOS
  end
end
