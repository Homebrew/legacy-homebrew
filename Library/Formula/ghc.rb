require 'formula'
require 'hardware'

class Ghc < Formula
  def options
    [
      ['--i386', 'Install 32-bit version of GHC (default).'],
      ['--x86_64', 'Install 64-bit version of GHC (experimental).']
    ]
  end

  homepage 'http://haskell.org/ghc/'
  version '7.0.3'
  if not ARGV.include? '--x86_64'
    url "http://www.haskell.org/ghc/dist/7.0.3/ghc-7.0.3-i386-apple-darwin.tar.bz2"
    md5 '649912037de756cf4570f84e5d53cf9c'
  else
    url "http://www.haskell.org/ghc/dist/7.0.3/ghc-7.0.3-x86_64-apple-darwin.tar.bz2"
    md5 '8a514a022ce21b8672f00054244faf26'
  end

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  def install
    if ARGV.include? '--x86_64' and !Hardware.is_64_bit?
      onoe "The x86_64 version is only for 64-bit hardware."
      exit 1
    end

    system "./configure --prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    32-bit version of GHC is installed by default, as the x84_64 version is
    labelled experimental. Override with --x86_64.

    This brew is for GHC only; you might also be interested in haskell-platform.
    EOS
  end
end
