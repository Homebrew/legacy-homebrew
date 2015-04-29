class Ghc < Formula
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-src.tar.xz"
  sha256 "92f3e3d67a637c587c49b61c704a670953509eb4b17a93c0c2ac153da4cd3aa0"

  revision 2

  bottle do
    revision 1
    sha256 "c2ec277a5445ece878b940838a93feed7a0c7733273ddcb26c07ec434f6ad800" => :yosemite
    sha256 "1107ca8344e4bf2229d78cee7b3ee7a86f06d950f4a3b6c5c58d66675922935b" => :mavericks
    sha256 "ad654abb4c2459b6cc764f275d5b6b141669e366f5051c58d871e54cb71a250c" => :mountain_lion
  end

  option "32-bit"
  option "with-tests", "Verify the build using the testsuite."
  deprecated_option "tests" => "with-tests"

  resource "gmp" do
    url "http://ftpmirror.gnu.org/gmp/gmp-6.0.0a.tar.bz2"
    mirror "ftp://ftp.gmplib.org/pub/gmp/gmp-6.0.0a.tar.bz2"
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
    resource "binary" do
      url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-x86_64-apple-darwin.tar.xz"
      sha256 "bc45de19efc831f7d5a3fe608ba4ebcd24cc0f414cac4bc40ef88a04640583f6"
    end
  end

  stable do
    resource "testsuite" do
      url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-testsuite.tar.xz"
      sha256 "33bbdfcfa50363526ea9671c8c1f01b7c5dec01372604d45cbb53bb2515298cb"
    end
  end

  def install
    if build.build_32_bit? || !MacOS.prefer_64_bit?
      ENV.m32
      # MPN_PATH: The lowest common denomenator asm paths that work on Darwin,
      # corresponding to Yonah and Merom. Obviates --disable-assembly.
      ENV["MPN_PATH"] = "x86/p6/sse2 x86/p6/p3mmx x86/p6/mmx x86/p6 x86/mmx x86 generic"
      ENV["ABI"] = "32"
      arch = "i386"
    else
      ENV["MPN_PATH"] = "x86_64/fastsse x86_64/core2 x86_64 generic"
      ENV["ABI"] = "64"
      arch = "x86_64"
    end

    # Build a static gmp rather than in-tree gmp, otherwise it links to brew's.
    # GMP *does not* build PIC by default without shared libraries so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    gmp = libexec/"integer-gmp"
    resource("gmp").stage do
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared"
      system "make"
      system "make", "check"
      ENV.deparallelize { system "make", "install" }
    end

    args = ["--with-gmp-includes=#{gmp}/include",
            "--with-gmp-libraries=#{gmp}/lib",
            "--with-ld=ld", # Avoid hardcoding superenv's ld on older machines.
            "--with-hs-cpp-flags=-E -undef -traditional", # Fix for :llvm.
            "--with-gcc=#{ENV.cc}"] # Always
    args << "--with-clang=#{ENV.cc}" if ENV.compiler == :clang
    args << "--with-gcc-4.2=#{ENV.cc}" if ENV.compiler == :llvm

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--build=#{arch}-apple-darwin", "--prefix=#{prefix}", *args
    system "make"

    if build.with? "tests"
      resource("testsuite").stage do
        testdirs = ["config", "driver", "mk", "tests", "timeout"]
        testdirs.each { |dir| (buildpath/dir).install Dir["#{dir}/*"] }
      end
      cd (buildpath/"tests") do
        system "make", "CLEANUP=1", "THREADS=#{ENV.make_jobs}", "fast"
      end
      system "make"
    end

    ENV.deparallelize { system "make", "install" }
  end

  test do
    hello = (testpath/"hello.hs")
    hello.write('main = putStrLn "Hello Homebrew"')
    output = `echo "main" | '#{bin}/ghci' #{hello}`
    assert $?.success?
    assert_match /Hello Homebrew/i, output
  end
end
