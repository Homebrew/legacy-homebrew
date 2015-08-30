class GambitScheme < Formula
  desc "Complete, portable implementation of Scheme"
  homepage "http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page"
  url "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.7/source/gambc-v4_7_9.tgz"
  sha256 "17e4a2eebbd0f5ebd807b4ad79a98b89b2a5eef00199c318a885db4ef950f14f"

  bottle do
    sha1 "4f04f85300495e2c3fad49206b57605d010ad1f7" => :mavericks
    sha1 "57c650e3539e41e084f29adf26160e920e3a068e" => :mountain_lion
    sha1 "f4002601e8f904d064909b5df30479a26c916f8d" => :lion
  end

  conflicts_with "ghostscript", :because => "both install `gsc` binaries"
  conflicts_with "scheme48", :because => "both install `scheme-r5rs` binaries"

  deprecated_option "enable-shared" => "with-shared"
  option "with-check", 'Execute "make check" before installing'
  option "with-shared", "Build Gambit Scheme runtime as shared library"

  fails_with :llvm
  fails_with :clang

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --libdir=#{lib}/gambit-c
      --infodir=#{info}
      --docdir=#{doc}
      --enable-single-host
    ]

    args << "--enable-shared" if build.with? "shared"

    system "./configure", *args
    system "make", "check" if build.with? "check"

    system "make"
    system "make", "install", "emacsdir=#{share}/emacs/site-lisp/#{name}"
  end

  test do
    system "#{bin}/gsi", "-e", '(print "hello world")'
  end
end
