class Ghc < Formula
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-src.tar.xz"
  sha256 "92f3e3d67a637c587c49b61c704a670953509eb4b17a93c0c2ac153da4cd3aa0"

  bottle do
    revision 1
    sha256 "c2ec277a5445ece878b940838a93feed7a0c7733273ddcb26c07ec434f6ad800" => :yosemite
    sha256 "1107ca8344e4bf2229d78cee7b3ee7a86f06d950f4a3b6c5c58d66675922935b" => :mavericks
    sha256 "ad654abb4c2459b6cc764f275d5b6b141669e366f5051c58d871e54cb71a250c" => :mountain_lion
  end

  option "32-bit"
  option "with-tests", "Verify the build using the testsuite."

  deprecated_option "tests" => "with-tests"

  # http://hackage.haskell.org/trac/ghc/ticket/6009
  depends_on :macos => :snow_leopard
  depends_on "gcc" if MacOS.version == :mountain_lion

  resource "gmp" do
    url "http://ftpmirror.gnu.org/gmp/gmp-6.0.0a.tar.bz2"
    mirror "ftp://ftp.gmplib.org/pub/gmp/gmp-6.0.0a.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.bz2"
    sha256 "7f8e9a804b9c6d07164cf754207be838ece1219425d64e28cfa3e70d5c759aaf"
  end

  if build.build_32_bit? || !MacOS.prefer_64_bit?
    resource "binary" do
      url "https://downloads.haskell.org/~ghc/7.4.2/ghc-7.4.2-i386-apple-darwin.tar.bz2"
      sha256 "80c946e6d66e46ca5d40755f3fbe3100e24c0f8036b850fd8767c4f9efd02bef"
    end
  elsif MacOS.version <= :lion
    # https://ghc.haskell.org/trac/ghc/ticket/9257
    resource "binary" do
      url "https://downloads.haskell.org/~ghc/7.6.3/ghc-7.6.3-x86_64-apple-darwin.tar.bz2"
      sha256 "f7a35bea69b6cae798c5f603471a53b43c4cc5feeeeb71733815db6e0a280945"
    end
  else
    # there is currently no 7.10.1 binary download for darwin,
    # so we use the one for 7.8.4 instead
    resource "binary" do
      url "https://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-x86_64-apple-darwin.tar.xz"
      sha256 "ebb6b0294534abda05af91798b43e2ea02481edacbf3d845a1e5925a211c67e3"
    end
  end

  stable do
    resource "testsuite" do
      url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-testsuite.tar.xz"
      sha256 "33bbdfcfa50363526ea9671c8c1f01b7c5dec01372604d45cbb53bb2515298cb"
    end
  end

  fails_with :llvm do
    cause <<-EOS.undent
      cc1: error: unrecognized command line option "-Wno-invalid-pp-token"
      cc1: error: unrecognized command line option "-Wno-unicode"
    EOS
  end

  if build.build_32_bit? || !MacOS.prefer_64_bit? || MacOS.version < :mavericks
    fails_with :clang do
      cause <<-EOS.undent
        Building with Clang configures GHC to use Clang as its preprocessor,
        which causes subsequent GHC-based builds to fail.
      EOS
    end
  end

  def install
    ENV.m32 if build.build_32_bit?

    # Build a static gmp (to avoid dynamic linking to ghc)
    gmp_prefix = buildpath/"gmp-static"
    resource("gmp").stage do
      gmp_args = ["--prefix=#{gmp_prefix}", "--enable-cxx", "--enable-shared=no"]
      gmp_args << "ABI=32" if build.build_32_bit?

      # https://github.com/Homebrew/homebrew/issues/20693
      gmp_args << "--disable-assembly" if build.build_32_bit? || build.bottle?

      system "./configure", *gmp_args
      system "make"
      system "make", "check"
      ENV.deparallelize
      system "make", "install"
    end

    # Move the main tarball contents into a subdirectory
    (buildpath+"Ghcsource").install Dir["*"]

    resource("binary").stage do
      # Define where the subformula will temporarily install itself
      subprefix = buildpath+"subfo"

      # ensure configure does not use Xcode 5 "gcc" which is actually clang
      system "./configure", "--prefix=#{subprefix}", "--with-gcc=#{ENV.cc}"

      if MacOS.version <= :lion
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
        arch = "i386"
      else
        arch = "x86_64"
      end

      # These will find their way into ghc's settings file, ensuring
      # that ghc will look in the Homebrew lib dir for native libs
      # (e.g., libgmp) even if the prefix is not /usr/local. Both are
      # necessary to avoid problems on systems with custom prefixes:
      # ghci fails without the first, compiling packages that depend
      # on native libs fails without the second.
      ENV["CONF_CC_OPTS_STAGE2"] = "-B#{HOMEBREW_PREFIX}/lib"
      ENV["CONF_GCC_LINKER_OPTS_STAGE2"] = "-L#{HOMEBREW_PREFIX}/lib"

      # ensure configure does not use Xcode 5 "gcc" which is actually clang
      system "./configure", "--prefix=#{prefix}",
                            "--build=#{arch}-apple-darwin",
                            "--with-gcc=#{ENV.cc}",
                            "--with-gmp-includes=#{gmp_prefix}",
                            "--with-gmp-libraries=#{gmp_prefix}"
      system "make"

      if build.with? "tests"
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
      # use clang, even when gcc was used to build ghc
      settings = Dir[lib/"ghc-*/settings"][0]
      inreplace settings, "\"#{ENV.cc}\"", "\"clang\""
    end
  end

  test do
    hello = (testpath/"hello.hs")
    hello.write('main = putStrLn "Hello Homebrew"')
    output = `echo "main" | '#{bin}/ghci' #{hello}`
    assert $?.success?
    assert_match /Hello Homebrew/i, output
  end
end
