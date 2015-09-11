class GambitScheme < Formula
  desc "Complete, portable implementation of Scheme"
  homepage "http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page"
  url "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.7/source/gambc-v4_7_9.tgz"
  sha256 "17e4a2eebbd0f5ebd807b4ad79a98b89b2a5eef00199c318a885db4ef950f14f"

  bottle do
    sha256 "d1d2cf026e85f5c62ebe7373c1eed03cd84c590ef3f588cba447fc912f9287d6" => :yosemite
    sha256 "7de3b06bde1d0a2a8ce3288dfed388aa4161f0753692cb53eade22372eba1bd3" => :mavericks
    sha256 "24f6d6f75f044bec4c7d0a87cc65e66234cc68e772d6a9d86ccd13495ce6aba5" => :mountain_lion
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
