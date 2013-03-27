require 'formula'

# The GHC bindist can be installed into any prefix.
# Building from source takes a very, very long time, and requires the bindist anyway.
# For these reasons, the normal way to install this package should be to download the
# bindist and install it into our prefix. This way we can achieve fast installation
# without having to build bottles ourselves, and it works for any prefix.
# We maintain the option of building from source, for people who want to do so.
#
# This formula supports two versions of GHC: the version compatible with the latest
# Haskell Platform (the default) and the current stable version (use --current). Since
# H-P is released far less frequently than GHC, these are going to be different versions
# most of the time.
#
# For GHC 7.4.2, we force building from source because there is an important patch that
# needs to be applied. For this version, it is appropriate to have bottles as well.
# However, for future versions they will not be needed, saving us a lot of time.

class NeedsSnowLeopard < Requirement
  satisfy MacOS.version >= :snow_leopard

  def message; <<-EOS.undent
    GHC requires OS X 10.6 or newer. The binary releases no longer work on
    Leopard. See the following issue for details:
        http://hackage.haskell.org/trac/ghc/ticket/6009
    EOS
  end
end

# Since the bindist package is needed for both binary and source installations, it should
# be the main formula's download. However, previous versions of this formula had the
# source package as the main download. Because of name mangling, both end up being called
# "ghc-7.4.2.tar.bz2", which can cause a checksum mismatch when reinstalling. To make
# things easier for our users, this disables name mangling for those downloads.

class OriginalNameDownloadStrategy < CurlDownloadStrategy
  def initialize name, package
    super '__UNKNOWN__', package
  end
end

class Ghctestsuite < Formula
  if build.include? 'current'
    url 'http://www.haskell.org/ghc/dist/7.6.2/ghc-7.6.2-testsuite.tar.bz2'
    sha1 'd3964077d68fe2c6bc5fd8eeeaa5cda541b20990'
  else
    url 'http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-testsuite.tar.bz2'
    sha1 'b5f38937872f7a10aaf89b11b0b417870d2cff7c'
  end
end

class Ghcsource < Formula
  if build.include? 'current'
    url 'http://www.haskell.org/ghc/dist/7.6.2/ghc-7.6.2-src.tar.bz2'
    sha1 '17329b0f1a401f3402cce13ba5e4cf8fbfa41a1d'
  else
    url 'http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-src.tar.bz2'
    sha1 '73b3b39dc164069bc80b69f7f2963ca1814ddf3d'

    def patches
      # Explained: http://hackage.haskell.org/trac/ghc/ticket/7040
      # Discussed: https://github.com/mxcl/homebrew/issues/13519
      # Remove: version > 7.4.2
      'http://hackage.haskell.org/trac/ghc/raw-attachment/ticket/7040/ghc7040.patch'
    end
  end

  def install real_prefix
    # Fix an assertion when linking ghc with llvm-gcc
    # https://github.com/mxcl/homebrew/issues/13650
    ENV['LD'] = 'ld'

    if Hardware.is_64_bit? and not build.build_32_bit?
      arch = 'x86_64'
    else
      ENV.m32 # Need to force this to fix build error on internal libgmp.
      arch = 'i386'
    end

    system "./configure", "--prefix=#{real_prefix}",
                          "--build=#{arch}-apple-darwin"
    system 'make'
    if build.include? 'tests'
      Ghctestsuite.new.brew do
        buildpath.install 'testsuite'
        cd (buildpath+'testsuite/tests') do
          system 'make', 'CLEANUP=1', "THREADS=#{ENV.make_jobs}", 'fast'
        end
      end
    end
    # Temporary j1 to stop an intermittent race condition
    system 'make', '-j1', 'install'
  end
end

class Ghc < Formula
  homepage 'http://haskell.org/ghc/'
  if build.include? 'current'
    version '7.6.2'
    if Hardware.is_64_bit? and not build.build_32_bit?
      url 'http://www.haskell.org/ghc/dist/7.6.2/ghc-7.6.2-x86_64-apple-darwin.tar.bz2', :using => OriginalNameDownloadStrategy
      sha1 'c5f2c36badf2a1c79259ccb1b1f0dcb8ff801356'
    else
      url 'http://www.haskell.org/ghc/dist/7.6.2/ghc-7.6.2-i386-apple-darwin.tar.bz2', :using => OriginalNameDownloadStrategy
      sha1 '8d93dc97bffdaf33e82a9425b8132aef054a001d'
    end
  else
    version '7.4.2'
    if Hardware.is_64_bit? and not build.build_32_bit?
      url 'http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-x86_64-apple-darwin.tar.bz2', :using => OriginalNameDownloadStrategy
      sha1 '7c655701672f4b223980c3a1068a59b9fbd08825'
    else
      url 'http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-i386-apple-darwin.tar.bz2', :using => OriginalNameDownloadStrategy
      sha1 '60f749893332d7c22bb4905004a67510992d8ef6'
    end

    bottle do
      revision 1
      sha1 '45b4f126123e71613564084851a8470fa4b06e6b' => :mountain_lion
      sha1 'a93d9aab9e3abfe586f9091f14057c6d90f6fdc0' => :lion
      sha1 '7d284bd3f3263be11229ac45f340fbf742ebbea6' => :snow_leopard
    end
  end

  env :std

  depends_on NeedsSnowLeopard

  option '32-bit'
  option 'tests', 'Verify the build using the testsuite in Fast Mode, 5 min'
  option 'source', 'Build from source'
  option 'current', 'Build the latest stable version'

  fails_with :clang do
    cause <<-EOS.undent
      Building with Clang configures GHC to use Clang as its preprocessor,
      which causes subsequent GHC-based builds to fail.
      EOS
  end

  def build_source?
    # 7.4.2 must always be built from source (unless using bottle)
    # because we need to apply a patch
    build.include? 'source' or not build.include? 'current'
  end

  def install
    binprefix = build_source? ? buildpath+'binprefix' : prefix

    system "./configure", "--prefix=#{binprefix}"
    # Temporary j1 to stop an intermittent race condition
    system 'make', '-j1', 'install'

    ENV.prepend 'PATH', binprefix/'bin', ':'
    if build_source?
      Ghcsource.new.brew {|f| f.install prefix}
    end
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only; you might also be interested in haskell-platform.

    If `ghc-pkg check` reports broken packages, you may have leftovers from an
    old installation. Try removing ~/.ghc
    EOS
  end
end
