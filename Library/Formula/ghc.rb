require 'formula'
require 'hardware'

class Ghc < Formula
  def options
    [
      ['--i386', 'Install 32-bit version of GHC (default).'],
      ['--x86_64', 'Install 64-bit version of GHC (not recommended).']
    ]
  end

  homepage 'http://haskell.org/ghc/'
  if ARGV.include? '--x86_64'
    url "http://www.haskell.org/ghc/dist/7.0.3/ghc-7.0.3-x86_64-apple-darwin.tar.bz2"
    version '7.0.3-x86_64'
    md5 '8a514a022ce21b8672f00054244faf26'
  else
    url "http://www.haskell.org/ghc/dist/7.0.3/ghc-7.0.3-i386-apple-darwin.tar.bz2"
    version '7.0.3-i386'
    md5 '649912037de756cf4570f84e5d53cf9c'
  end

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  def install
    if ARGV.include? '--x86_64'
      if !Hardware.is_64_bit?
        onoe <<-EOS.undent
          The x86_64 version is for 64-bit hardware, which this is not!
        EOS
        exit 1
      end

      ENV.m64
      opoo <<-EOS.undent
        The x86_64 version of ghc is labelled experimental, as it's unstable.
        See #{Tty.em}http://article.gmane.org/gmane.comp.lang.haskell.platform/1496#{Tty.reset}
      EOS
    else
      if Hardware.is_64_bit?
        ohai <<-EOS.undent
          Installing the stable 32-bit version of ghc, override with --x86_64.
        EOS
      end
    end

    # This is a precompiled bindist and ready to install.
    # We just have to configure the final install location.
    system "./configure --prefix=#{prefix}"
    system "make install"

    puts <<-EOS.undent
      The Haskell packaging system is cabal, which plays nicely with homebrew.
      You can learn about it at http://www.haskell.org/haskellwiki/Cabal-Install

      Download cabal-install from http://hackage.haskell.org/package/cabal-install
      You need a version >= 0.10.2 of cabal-install for this version of GHC.
    EOS
  end
end
