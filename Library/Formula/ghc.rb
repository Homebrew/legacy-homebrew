class Ghc < Formula
  homepage "http://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-src.tar.xz"
  sha256 "c319cd94adb284177ed0e6d21546ed0b900ad84b86b87c06a99eac35152982c4"

  bottle do
    sha1 "34077e696ada63791ff32e044c51c8e538834b83" => :yosemite
    sha1 "3780f6768dc740fb51fa3906cccb28ab06ce5acc" => :mavericks
    sha1 "296802648e2b2bc26fcb01025fb1fa8ab583e64a" => :mountain_lion
  end

  devel do
    url "https://downloads.haskell.org/~ghc/7.10.1-rc2/ghc-7.10.0.20150123-src.tar.xz"
    version "7.10.1-rc2"
    sha256 "766596f9b09b2cdd8bd477754f0e02ea8f7e40e4f5b0522cf585942fb2fec546"
  end

  option "32-bit"
  option "with-tests", "Verify the build using the testsuite."

  deprecated_option "tests" => "with-tests"

  # http://hackage.haskell.org/trac/ghc/ticket/6009
  depends_on :macos => :snow_leopard
  depends_on "gmp"
  depends_on "gcc" if MacOS.version == :mountain_lion

  if OS.linux?
    resource "binary" do
      url "http://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-x86_64-unknown-linux.tar.bz2"
      sha256 "da962575e2503dec250252d72a94b6bf69baef7a567b88e90fd6400ada527210"
    end
  elsif build.build_32_bit? || !MacOS.prefer_64_bit?
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
    resource "binary" do
      # there is currently no 7.8.4 binary download for darwin
      url "https://downloads.haskell.org/~ghc/7.8.3/ghc-7.8.3-x86_64-apple-darwin.tar.xz"
      sha256 "dba74c4cfb3a07d243ef17c4aebe7fafe5b43804468f469fb9b3e5e80ae39e38"
    end
  end

  stable do
    resource "testsuite" do
      url "https://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-testsuite.tar.xz"
      sha256 "d0332f30868dcd0e7d64d1444df05737d1f3cf4b09f9cfbfec95f8831ce42561"
    end
  end

  devel do
    resource "testsuite" do
      url "https://downloads.haskell.org/~ghc/7.10.1-rc2/ghc-7.10.0.20150123-testsuite.tar.xz"
      sha256 "051d4659421dec257827d7de7df8a99806f4bf575102013dda4006fccee11f76"
    end
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
    # Move the main tarball contents into a subdirectory
    (buildpath+"Ghcsource").install Dir["*"]

    resource("binary").stage do
      # Change the dynamic linker and RPATH of the binary executables.
      if OS.linux? && Formula["glibc"].installed?
        keg = Keg.new(prefix)
        Dir["ghc/stage2/build/tmp/ghc-stage2", "utils/*/dist*/build/tmp/*"].each { |file|
          keg.change_rpath(Pathname.new(file), HOMEBREW_PREFIX.to_s)
        }
      end

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
                            ("--build=#{arch}-apple-darwin" if OS.mac?),
                            "--with-gcc=#{ENV.cc}"
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
      inreplace settings, "\"#{ENV.cc}\"", "\"clang\"" if OS.mac?
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
