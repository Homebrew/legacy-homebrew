require 'formula'

class Ghc < Formula
  homepage "http://haskell.org/ghc/"
  url "https://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-src.tar.xz"
  sha256 "b0cd96a549ba3b5e512847a4a8cd1a3174e4b2b75dadfc41c568fb812887b958"

  bottle do
    sha1 "9bff37aa9a75eb7ebfbabb97a37502541cd3fdaa" => :yosemite
    sha1 "510ba119620aaeb992e359a5a30618983cb6d4fb" => :mavericks
    sha1 "234248dd606849994fe8950de5085832932e398b" => :mountain_lion
    sha1 "2ec3d750f54d5e032fab416995b37a2fa337f77d" => :lion
  end

  option "32-bit"
  option "tests", "Verify the build using the testsuite."

  # http://hackage.haskell.org/trac/ghc/ticket/6009
  depends_on :macos => :snow_leopard
  depends_on "gmp"
  depends_on "gcc" if MacOS.version == :mountain_lion

  if build.build_32_bit? || !MacOS.prefer_64_bit?
    resource "binary" do
      url "https://www.haskell.org/ghc/dist/7.4.2/ghc-7.4.2-i386-apple-darwin.tar.bz2"
      sha256 "80c946e6d66e46ca5d40755f3fbe3100e24c0f8036b850fd8767c4f9efd02bef"
    end
  elsif MacOS.version <= :lion
    # https://ghc.haskell.org/trac/ghc/ticket/9257
    resource "binary" do
      url "https://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-apple-darwin.tar.bz2"
      sha256 "f7a35bea69b6cae798c5f603471a53b43c4cc5feeeeb71733815db6e0a280945"
    end
  else
    resource "binary" do
      url "https://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-x86_64-apple-darwin.tar.xz"
      sha256 "dba74c4cfb3a07d243ef17c4aebe7fafe5b43804468f469fb9b3e5e80ae39e38"
    end
  end

  resource "testsuite" do
    url "https://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-testsuite.tar.xz"
    sha256 "91ef5bd19d0bc1cd496de08218f7ac8a73c69de64d903e314c6beac51ad06254"
  end

  resource "Cabal" do
    url "https://www.haskell.org/cabal/release/cabal-1.18.1.4/Cabal-1.18.1.4.tar.gz"
    sha1 "3d23d0ad3c5dc0bc4440b50ca2c9a9a47396836a"
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

    # Here we imitate the Haskell Platform's packaging of GHC by including
    # a later version of Cabal, “which fixes a particularly nasty problem with
    # haddock, -XCPP, and clang based systems.”
    # (q.v. https://www.haskell.org/platform/mac.html)
    cabal_dir = buildpath/"Ghcsource/libraries/Cabal"
    orig_cabal = cabal_dir/"Cabal.bak"
    mv cabal_dir/"Cabal", orig_cabal
    (cabal_dir/"Cabal").install resource("Cabal")
    # there are some GHC-related files that don't come in Cabal's tarball
    mv orig_cabal/"GNUmakefile", cabal_dir/"Cabal/GNUmakefile"
    mv orig_cabal/"ghc.mk", cabal_dir/"Cabal/ghc.mk"
    mv orig_cabal/"prologue.txt", cabal_dir/"Cabal/prologue.txt"
    rm_rf orig_cabal

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

      # ensure configure does not use Xcode 5 "gcc" which is actually clang
      system "./configure", "--prefix=#{prefix}",
                            "--build=#{arch}-apple-darwin",
                            "--with-gcc=#{ENV.cc}"
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
