class Ghc < Formula
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-src.tar.xz"
  sha256 "92f3e3d67a637c587c49b61c704a670953509eb4b17a93c0c2ac153da4cd3aa0"

  bottle do
    sha256 "823759e556e408caf5624be4372905bb28b11cbdf8d539b40e81a40d6980b709" => :yosemite
    sha256 "c696456ac242241931a5164874c3995bed14a4115abe79dc72a8432320b34f92" => :mavericks
    sha256 "9cd86dd822512f3b82e6c7fb6b83300cd686721cdbf468cdb8f1a2a14f9f46e3" => :mountain_lion
  end

  option "32-bit"
  option "with-tests", "Verify the build using the testsuite."

  deprecated_option "tests" => "with-tests"

  # http://hackage.haskell.org/trac/ghc/ticket/6009
  depends_on :macos => :snow_leopard
  depends_on "gmp"
  depends_on "gcc" if MacOS.version == :mountain_lion

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
    # Copy gmp static libraries to build path (to avoid dynamic linking)
    (buildpath/"gmp-lib-static").mkpath
    cp Dir.glob("#{Formula["gmp"].lib}/*.a"), buildpath/"gmp-lib-static/"

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
        ENV.m32 # Need to force this to fix build error on internal libgmp_ar.
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
                            "--with-gmp-includes=#{buildpath}/gmp-lib-static"
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
