class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3b-src.tar.bz2"
  sha256 "b0bb177b8095de6074e5a3538e55fd1fc187dae6eb6ae36b05582c55f7d2db6f"

  bottle do
    sha256 "72c6c729ea385aaebfa22b55fe31b85f46e423a510c83d2f76c8f57336f9bf2c" => :el_capitan
    sha256 "3914b0875845c0e419c440c1b5833631ea709e6e8d5d9bf546422852c4c96ea8" => :yosemite
    sha256 "3ca8542ed077871a9da2e7af1a2362eb6ddc52501e6625fa5b06e9fda288e980" => :mavericks
  end

  option "with-test", "Verify the build using the testsuite"
  deprecated_option "tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  resource "gmp" do
    url "http://ftpmirror.gnu.org/gmp/gmp-6.1.0.tar.bz2"
    mirror "https://gmplib.org/download/gmp/gmp-6.1.0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.0.tar.bz2"
    sha256 "498449a994efeba527885c10405993427995d3f86b8768d8cdf8d9dd7c6b73e8"
  end

  if MacOS.version <= :lion
    fails_with :clang do
      cause <<-EOS.undent
        Fails to bootstrap ghc-cabal. Error is:
          libraries/Cabal/Cabal/Distribution/Compat/Binary/Class.hs:398:14:
              The last statement in a 'do' block must be an expression
                n <- get :: Get Int getMany n
      EOS
    end
  end

  resource "binary" do
    if MacOS.version <= :lion
      url "https://downloads.haskell.org/~ghc/7.6.3/ghc-7.6.3-x86_64-apple-darwin.tar.bz2"
      sha256 "f7a35bea69b6cae798c5f603471a53b43c4cc5feeeeb71733815db6e0a280945"
    else
      url "https://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-x86_64-apple-darwin.tar.xz"
      sha256 "852781d43d41cd55d02f818fe798bb4d1f7e52f488408167f413f7948cf1e7df"
    end
  end

  resource "testsuite" do
    url "https://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-testsuite.tar.xz"
    sha256 "50c151695c8099901334a8478713ee3bb895a90132e2b75d1493961eb8ec643a"
  end

  def install
    # Build a static gmp rather than in-tree gmp, otherwise it links to brew's.
    gmp = libexec/"integer-gmp"

    # MPN_PATH: The lowest common denomenator asm paths that work on Darwin,
    # corresponding to Yonah and Merom. Obviates --disable-assembly.
    ENV["MPN_PATH"] = "x86_64/fastsse x86_64/core2 x86_64 generic" if build.bottle?

    # GMP *does not* use PIC by default without shared libs  so --with-pic
    # is mandatory or else you'll get "illegal text relocs" errors.
    resource("gmp").stage do
      system "./configure", "--prefix=#{gmp}", "--with-pic", "--disable-shared"
      system "make"
      system "make", "check"
      ENV.deparallelize { system "make", "install" }
    end

    args = ["--with-gmp-includes=#{gmp}/include",
            "--with-gmp-libraries=#{gmp}/lib",
            "--with-ld=ld", # Avoid hardcoding superenv's ld.
            "--with-gcc=#{ENV.cc}"] # Always.

    if ENV.compiler == :clang
      args << "--with-clang=#{ENV.cc}"
    elsif ENV.compiler == :llvm
      args << "--with-gcc-4.2=#{ENV.cc}"
    end

    resource("binary").stage do
      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    if build.with? "test"
      resource("testsuite").stage { buildpath.install Dir["*"] }
      cd "testsuite" do
        system "make", "clean"
        system "make", "CLEANUP=1", "THREADS=#{ENV.make_jobs}", "fast"
      end
    end

    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    system "#{bin}/runghc", testpath/"hello.hs"
  end
end
