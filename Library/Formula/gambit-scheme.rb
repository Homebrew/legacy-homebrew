class GambitScheme < Formula
  desc "Complete, portable implementation of Scheme"
  homepage "http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page"
  url "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.7/source/gambc-v4_7_3.tgz"
  sha256 "59c4c62f2cfaf698b54a862e7af9c1b3e4cc27e46d386f31c66e00fed4701777"

  bottle do
    sha1 "4f04f85300495e2c3fad49206b57605d010ad1f7" => :mavericks
    sha1 "57c650e3539e41e084f29adf26160e920e3a068e" => :mountain_lion
    sha1 "f4002601e8f904d064909b5df30479a26c916f8d" => :lion
  end

  conflicts_with "ghostscript", :because => "both install `gsc` binaries"
  conflicts_with "scheme48", :because => "both install `scheme-r5rs` binaries"

  option "with-check", 'Execute "make check" before installing'
  option "enable-shared", "Build Gambit Scheme runtime as shared library"

  fails_with :llvm

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --libdir=#{lib}/gambit-c
      --infodir=#{info}
      --docdir=#{doc}
    ]

    # Recommended to improve the execution speed and compactness
    # of the generated executables. Increases compilation times.
    # Don't enable this when using clang, per configure warning.
    args << "--enable-single-host" unless ENV.compiler == :clang

    args << "--enable-shared" if build.include? "enable-shared"

    if ENV.compiler == :clang
      opoo <<-EOS.undent
        Gambit will build with Clang, however the build may take longer and
        produce substandard binaries. If you have GCC, you can get a faster
        build and faster execution with:
          brew install gambit-scheme --cc=gcc-4.2 # or 4.7, 4.8, etc.
      EOS
    end

    system "./configure", *args
    system "make check" if build.with? "check"

    ENV.j1
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gsi", "-e", '(print "hello world")'
  end
end
