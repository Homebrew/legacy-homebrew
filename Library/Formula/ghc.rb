require 'formula'

class Ghcbinary < Formula
  if Hardware.is_64_bit? and not build.build_32_bit?
    url 'http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-x86_64-apple-darwin.tar.bz2'
    sha1 '7c655701672f4b223980c3a1068a59b9fbd08825'
  else
    url 'http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-i386-apple-darwin.tar.bz2'
    sha1 '60f749893332d7c22bb4905004a67510992d8ef6'
  end
  version '7.4.2'
end

class Ghctestsuite < Formula
  url 'https://github.com/ghc/testsuite/archive/ghc-7.6.3-release.tar.gz'
  sha1 '6a1973ae3cccdb2f720606032ae84ffee8680ca1'
end

class Ghc < Formula
  homepage 'http://haskell.org/ghc/'
  url 'http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-src.tar.bz2'
  sha1 '8938e1ef08b37a4caa071fa169e79a3001d065ff'

  env :std

  # http://hackage.haskell.org/trac/ghc/ticket/6009
  depends_on :macos => :snow_leopard

  option '32-bit'
  option 'tests', 'Verify the build using the testsuite in Fast Mode, 5 min'

  bottle do
    sha1 '332ed50be17831557b5888f7e8395f1beb008731' => :mountain_lion
    sha1 '64a7548eb2135a4b5f2276e59f435a39c2d2961f' => :lion
    sha1 '166bf3c8a512b58da4119b2997a1f45c1f7c65b5' => :snow_leopard
  end

  fails_with :clang do
    cause <<-EOS.undent
      Building with Clang configures GHC to use Clang as its preprocessor,
      which causes subsequent GHC-based builds to fail.
      EOS
  end

  def patches
    # Fixes 7.6.3 compilation on 10.9
    DATA if MacOS.version >= :mavericks
  end

  def install
    # Move the main tarball contents into a subdirectory
    (buildpath+'Ghcsource').install Dir['*']

    Ghcbinary.new.brew do
      # Define where the subformula will temporarily install itself
      subprefix = buildpath+'subfo'

      # ensure configure does not use Xcode 5 "gcc" which is actually clang
      args = ["--prefix=#{subprefix}"]
      args << "--with-gcc=#{ENV.cc}" if ENV.compiler == :gcc

      system "./configure", *args
      ENV.j1 # Fixes an intermittent race condition
      system 'make install'
      ENV.prepend 'PATH', subprefix/'bin', ':'
    end

    cd 'Ghcsource' do
      # Fix an assertion when linking ghc with llvm-gcc
      # https://github.com/mxcl/homebrew/issues/13650
      ENV['LD'] = 'ld'

      if Hardware.is_64_bit? and not build.build_32_bit?
        arch = 'x86_64'
      else
        ENV.m32 # Need to force this to fix build error on internal libgmp_ar.
        arch = 'i386'
      end

      # ensure configure does not use Xcode 5 "gcc" which is actually clang
      args = ["--prefix=#{prefix}", "--build=#{arch}-apple-darwin"]
      args << "--with-gcc=#{ENV.cc}" if ENV.compiler == :gcc

      system "./configure", *args
      system 'make'
      if build.include? 'tests'
        Ghctestsuite.new.brew do
          (buildpath+'Ghcsource/config').install Dir['config/*']
          (buildpath+'Ghcsource/driver').install Dir['driver/*']
          (buildpath+'Ghcsource/mk').install Dir['mk/*']
          (buildpath+'Ghcsource/tests').install Dir['tests/*']
          (buildpath+'Ghcsource/timeout').install Dir['timeout/*']
          cd (buildpath+'Ghcsource/tests') do
            system 'make', 'CLEANUP=1', "THREADS=#{ENV.make_jobs}", 'fast'
          end
        end
      end
      system 'make'
      ENV.j1 # Fixes an intermittent race condition
      system 'make install'
    end
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only; you might also be interested in haskell-platform.
    EOS
  end
end

__END__
diff --git a/includes/HsFFI.h b/includes/HsFFI.h
index 652fbea..a21811e 100644
--- a/includes/HsFFI.h
+++ b/includes/HsFFI.h
@@ -21,7 +21,7 @@ extern "C" {
 #include "stg/Types.h"

 /* get limits for integral types */
-#ifdef HAVE_STDINT_H
+#if defined HAVE_STDINT_H && !defined USE_INTTYPES_H_FOR_RTS_PROBES_D
 /* ISO C 99 says:
  * "C++ implementations should define these macros only when
  * __STDC_LIMIT_MACROS is defined before <stdint.h> is included."
diff --git a/rts/RtsProbes.d b/rts/RtsProbes.d
index 13f40f8..226f881 100644
--- a/rts/RtsProbes.d
+++ b/rts/RtsProbes.d
@@ -6,6 +6,12 @@
  *
  * ---------------------------------------------------------------------------*/

+#ifdef __APPLE__ && __MACH__
+# if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9
+#  define USE_INTTYPES_H_FOR_RTS_PROBES_D
+# endif
+#endif
+
 #include "HsFFI.h"
 #include "rts/EventLogFormat.h"

diff --git a/utils/mkdirhier/mkdirhier.sh b/utils/mkdirhier/mkdirhier.sh
index 4c5d5f7..80762f4 100644
--- a/utils/mkdirhier/mkdirhier.sh
+++ b/utils/mkdirhier/mkdirhier.sh
@@ -1,4 +1,4 @@
 #!/bin/sh

-mkdir -p ${1+"$@"}
+mkdir -p ${1+"./$@"}
