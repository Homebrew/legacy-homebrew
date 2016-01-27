class GambitScheme < Formula
  desc "Complete, portable implementation of Scheme"
  homepage "http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page"
  url "https://www.iro.umontreal.ca/~gambit/download/gambit/v4.8/source/gambit-v4_8_4.tgz"
  sha256 "b3153649440bde0f613c09b5038e2cc887784277e078cdea3e6703e4a582a0bf"

  bottle do
    sha256 "d1d2cf026e85f5c62ebe7373c1eed03cd84c590ef3f588cba447fc912f9287d6" => :yosemite
    sha256 "7de3b06bde1d0a2a8ce3288dfed388aa4161f0753692cb53eade22372eba1bd3" => :mavericks
    sha256 "24f6d6f75f044bec4c7d0a87cc65e66234cc68e772d6a9d86ccd13495ce6aba5" => :mountain_lion
  end

  conflicts_with "ghostscript", :because => "both install `gsc` binaries"
  conflicts_with "scheme48", :because => "both install `scheme-r5rs` binaries"

  option "with-test", 'Execute "make check" before installing'
  option "with-shared", "Build Gambit Scheme runtime as shared library"

  deprecated_option "with-check" => "with-test"
  deprecated_option "enable-shared" => "with-shared"

  fails_with :llvm
  fails_with :clang
  # According to the docs, gambit-scheme requires absurd amounts of RAM
  # to build using GCC 4.2 or 4.3; see
  # https://github.com/mistydemeo/tigerbrew/issues/389
  fails_with :gcc
  fails_with :gcc => "4.3"

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
    system "make", "check" if build.with? "test"

    system "make"
    system "make", "install", "emacsdir=#{share}/emacs/site-lisp/#{name}"
  end

  test do
    system "#{bin}/gsi", "-e", '(print "hello world")'
  end
end
