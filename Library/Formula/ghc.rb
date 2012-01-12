require 'formula'

class Ghc < Formula
  homepage 'http://haskell.org/ghc/'
  if not ARGV.build_devel?
    version '7.0.4'
    if ARGV.include? '--64bit'
      url "http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-x86_64-apple-darwin.tar.bz2"
      md5 'af89d3d2ca6e9b23384baacb7d8161dd'
    else
      url "http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-i386-apple-darwin.tar.bz2"
      md5 'ce297e783d113cf1547386703d1b1061'
    end
  else
    version '7.2.2'
    if ARGV.include? '--64bit'
      url "http://www.haskell.org/ghc/dist/7.2.2/ghc-7.2.2-x86_64-apple-darwin.tar.bz2"
      md5 '97c9dc221fcf9eb8635f05ba08eca0c9'
    else
      url "http://www.haskell.org/ghc/dist/7.2.2/ghc-7.2.2-i386-apple-darwin.tar.bz2"
      md5 '1084f44b0d9e5ea5d3bf9b699b6e3e35'
    end
  end

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  def options
    [['--64bit', 'Install 64-bit version of GHC (experimental).']]
  end

  def install
    if ARGV.build_devel?
      opoo "The current version of haskell-platform will NOT work with this version of GHC!"
    end
    if ARGV.include? '--64bit'
      if Hardware.is_64_bit?
        opoo "The x86_64 version is experimental!"
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
