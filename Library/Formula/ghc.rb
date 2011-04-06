require 'formula'
# require 'hardware'

class Ghc < Formula
  homepage 'http://haskell.org/ghc/'
  version '7.0.3'
  if ARGV.include? '--64bit'
    url "http://www.haskell.org/ghc/dist/7.0.3/ghc-7.0.3-x86_64-apple-darwin.tar.bz2"
    md5 '8a514a022ce21b8672f00054244faf26'
  else
    url "http://www.haskell.org/ghc/dist/7.0.3/ghc-7.0.3-i386-apple-darwin.tar.bz2"
    md5 '649912037de756cf4570f84e5d53cf9c'
  end

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  def options
    [['--64bit', 'Install 64-bit version of GHC (experimental).']]
  end

  def install
    if ARGV.include? '--64bit'
      if Hardware.is_64_bit?
        onoe "The x86_64 version is experimental!"
      else
        onoe "The x86_64 version is only for 64-bit hardware."
        exit 1
      end
    end

    system "./configure --prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    The 32-bit version of GHC is installed by default, as the x84_64 version is
    labelled experimental. Override with `--64bit`.

    This brew is for GHC only; you might also be interested in haskell-platform.
    EOS
  end
end
