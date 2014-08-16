require 'formula'

class Ghc < Formula
  homepage "https://haskell.org/ghc/"
  url "https://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-src.tar.bz2"
  sha1 "b5b3f9ff9d430fef5147c941b1ff5403cb80554b"
  revision 4

  bottle do
    sha1 "75efb035488ce9f3119e621748370795d454f9c6" => :mavericks
    sha1 "f288ec14e98973866babaf6aa63ceb612e39750c" => :mountain_lion
    sha1 "73e1732a5e09557084bf25c5e1a6fbb17c5d3ee1" => :lion
  end

  option "32-bit"

  # http://hackage.haskell.org/trac/ghc/ticket/6009
  depends_on :macos => :snow_leopard
  depends_on "gmp"

  # These don't work inside of a `stable do` block
  if build.build_32_bit? || !MacOS.prefer_64_bit? || MacOS.version < :mavericks
    depends_on "gcc" if MacOS.version >= :mountain_lion
    env :std

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
