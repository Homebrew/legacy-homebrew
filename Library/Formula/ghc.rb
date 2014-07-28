require 'formula'

class Ghc < Formula
  homepage "http://haskell.org/ghc/"
  url "http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-src.tar.bz2"
  sha1 "8938e1ef08b37a4caa071fa169e79a3001d065ff"
  revision 3

  bottle do
    sha1 "75efb035488ce9f3119e621748370795d454f9c6" => :mavericks
    sha1 "f288ec14e98973866babaf6aa63ceb612e39750c" => :mountain_lion
    sha1 "73e1732a5e09557084bf25c5e1a6fbb17c5d3ee1" => :lion
  end

  option "32-bit"
  option "tests", "Verify the build using the testsuite."

  # http://hackage.haskell.org/trac/ghc/ticket/6009
  depends_on :macos => :snow_leopard
  depends_on "gmp"

  devel do
    url "https://www.haskell.org/ghc/dist/7.8.2/ghc-7.8.2-src.tar.xz"
    sha1 "fe86ae790b7e8e5b4c78db7a914ee375bc6d9fc3"

    resource "testsuite" do
      url "https://www.haskell.org/ghc/dist/7.8.2/ghc-7.8.2-testsuite.tar.xz"
      sha1 "3abe4e0ebbed17e825573f0f34be0eca9179f9e4"
    end
  end

  resource "binary_7.8" do
    url "https://www.haskell.org/ghc/dist/7.8.2/ghc-7.8.2-x86_64-apple-darwin-mavericks.tar.xz"
    sha1 "5219737fb38f882532712047f6af32fc73a91f0f"
  end

  resource "binary" do
    url "http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-x86_64-apple-darwin.tar.bz2"
    sha1 "7c655701672f4b223980c3a1068a59b9fbd08825"
  end

  resource "binary32" do
    url "http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-i386-apple-darwin.tar.bz2"
    sha1 "60f749893332d7c22bb4905004a67510992d8ef6"
  end

  # These don't work inside of a `stable do` block
  if build.stable? || build.build_32_bit? || !MacOS.prefer_64_bit? || MacOS.version < :mavericks
    depends_on "gcc" if MacOS.version >= :mountain_lion
    env :std

    fails_with :clang do
      cause <<-EOS.undent
        Building with Clang configures GHC to use Clang as its preprocessor,
        which causes subsequent GHC-based builds to fail.
      EOS
    end
  end

  stable do
    resource "testsuite" do
      url "https://github.com/ghc/testsuite/archive/ghc-7.6.3-release.tar.gz"
      sha1 "6a1973ae3cccdb2f720606032ae84ffee8680ca1"
    end

    # Fixes 7.6.3 compilation on 10.9
    patch :DATA if MacOS.version >= :mavericks
  end

  def install
    # Move the main tarball contents into a subdirectory
    (buildpath+"Ghcsource").install Dir["*"]

    if build.build_32_bit? || !MacOS.prefer_64_bit?
      binary_resource = "binary32"
    elsif MacOS.version >= :mavericks && build.devel?
      binary_resource = "binary_7.8"
    else
      binary_resource = "binary"
    end

    resource(binary_resource).stage do
      # Define where the subformula will temporarily install itself
      subprefix = buildpath+"subfo"

      # ensure configure does not use Xcode 5 "gcc" which is actually clang
      args = ["--prefix=#{subprefix}"]
      args << "--with-gcc=#{ENV.cc}"

      system "./configure", *args
      if build.devel? and MacOS.version <= :lion
        # __thread is not supported on Lion but configure enables it anyway.
        File.open("mk/config.h", "a") do |file|
          file.write("#undef CC_SUPPORTS_TLS")
        end
      end

      # -j1 fixes an intermittent race condition
      system "make", "-j1", "install"
      ENV.prepend_path "PATH", subprefix/"bin"
    end

    cd "Ghcsource" do
      # Fix an assertion when linking ghc with llvm-gcc
      # https://github.com/Homebrew/homebrew/issues/13650
      ENV["LD"] = "ld"

      if build.build_32_bit? || !MacOS.prefer_64_bit?
        ENV.m32 # Need to force this to fix build error on internal libgmp_ar.
        arch = "i386"
      else
        arch = "x86_64"
      end

      # ensure configure does not use Xcode 5 "gcc" which is actually clang
      args = ["--prefix=#{prefix}", "--build=#{arch}-apple-darwin"]
      args << "--with-gcc=#{ENV.cc}"

      system "./configure", *args
      system "make"

      if build.include? "tests"
        resource("testsuite").stage do
          cd "testsuite" do
            (buildpath+"Ghcsource/config").install Dir["config/*"]
            (buildpath+"Ghcsource/driver").install Dir["driver/*"]
            (buildpath+"Ghcsource/mk").install Dir["mk/*"]
            (buildpath+"Ghcsource/tests").install Dir["tests/*"]
            (buildpath+"Ghcsource/timeout").install Dir["timeout/*"]
          end
          cd (buildpath+"Ghcsource/tests") do
            system "make", "CLEANUP=1", "THREADS=#{ENV.make_jobs}", "fast"
          end
        end
      end

      system "make"
      # -j1 fixes an intermittent race condition
      system "make", "-j1", "install"
      if build.devel?
        # use clang, even when gcc was used to build ghc
        settings = Dir[lib/"ghc-*/settings"][0]
        inreplace settings, "\"#{ENV.cc}\"", "\"clang\""
      end
    end
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only; you might also be interested in cabal-install
    or haskell-platform.
    EOS
  end

  test do
    hello = (testpath/"hello.hs")
    hello.write('main = putStrLn "Hello Homebrew"')
    output = `echo "main" | '#{bin}/ghci' #{hello}`
    assert $?.success?
    assert_match /Hello Homebrew/i, output
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
