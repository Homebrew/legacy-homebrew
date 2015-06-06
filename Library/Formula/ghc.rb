class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-src.tar.xz"
  sha256 "92f3e3d67a637c587c49b61c704a670953509eb4b17a93c0c2ac153da4cd3aa0"

  revision 1

  bottle do
    sha256 "969cc9bfd6574070982d1bd6678f1eeee430940d00d10b70204528cc9ce84c07" => :yosemite
    sha256 "bb82b24644330273d5e8b02b5c3ced76cbde1b388a45047327db3cfd5f07fe1f" => :mavericks
    sha256 "8b7900d0f6a72312969494b70ace58ed03ef8624b52d5db63ecccc00cf056e98" => :mountain_lion
  end

  option "with-tests", "Verify the build using the testsuite."
  deprecated_option "tests" => "with-tests"

  resource "gmp" do
    url "http://ftpmirror.gnu.org/gmp/gmp-6.0.0a.tar.bz2"
    mirror "https://gmplib.org/download/gmp/gmp-6.0.0a.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.bz2"
    sha256 "7f8e9a804b9c6d07164cf754207be838ece1219425d64e28cfa3e70d5c759aaf"
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
    if OS.linux?
      # Using 7.10.1 gives the error message:
      # BFD: dist-install/build/stj2R30K: Not enough room for program headers, try linking with -N
      # strip:dist-install/build/stj2R30K[.note.gnu.build-id]: Bad value
      url "http://downloads.haskell.org/~ghc/7.6.3/ghc-7.6.3-x86_64-unknown-linux.tar.bz2"
      sha256 "398dd5fa6ed479c075ef9f638ef4fc2cc0fbf994e1b59b54d77c26a8e1e73ca0"
    elsif MacOS.version <= :lion
      url "https://downloads.haskell.org/~ghc/7.6.3/ghc-7.6.3-x86_64-apple-darwin.tar.bz2"
      sha256 "f7a35bea69b6cae798c5f603471a53b43c4cc5feeeeb71733815db6e0a280945"
    else
      url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-x86_64-apple-darwin.tar.xz"
      sha256 "bc45de19efc831f7d5a3fe608ba4ebcd24cc0f414cac4bc40ef88a04640583f6"
    end
  end

  resource "testsuite" do
    url "https://downloads.haskell.org/~ghc/7.10.1/ghc-7.10.1-testsuite.tar.xz"
    sha256 "33bbdfcfa50363526ea9671c8c1f01b7c5dec01372604d45cbb53bb2515298cb"
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
            # The offending -Wno-[unicode] flags get appended here, so set:
            "--with-hs-cpp-flags=-E -undef -traditional",
            "--with-gcc=#{ENV.cc}"] # Always.

    if ENV.compiler == :clang
      args << "--with-clang=#{ENV.cc}"
    elsif ENV.compiler == :llvm
      args << "--with-gcc-4.2=#{ENV.cc}"
    end

    resource("binary").stage do
      # Change the dynamic linker and RPATH of the binary executables.
      if OS.linux? && Formula["glibc"].installed?
        keg = Keg.new(prefix)
        Dir["ghc/stage2/build/tmp/ghc-stage2", "libraries/*/dist-install/build/*.so", "rts/dist/build/*.so*", "utils/*/dist*/build/tmp/*"].each { |s|
          file = Pathname.new(s)
          keg.change_rpath(file, HOMEBREW_PREFIX.to_s) if file.mach_o_executable? || file.dylib?
        }
      end

      binary = buildpath/"binary"

      system "./configure", "--prefix=#{binary}", *args
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    system "./configure", "--prefix=#{prefix}", *args
    system "make"

    if build.with? "tests"
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
    system "runghc", testpath/"hello.hs"
  end
end
