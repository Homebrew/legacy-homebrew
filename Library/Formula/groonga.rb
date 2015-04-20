class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.2.tar.gz"
  sha1 "737e2196ea144a7c39ed778c5b748c121128bccf"

  bottle do
    sha256 "0eaaac19af8871810041243880cb55158cdd461a4bd43cf6820b060d1ebf1ded" => :yosemite
    sha256 "8729a2289f99cbc5cb3d28065c2385987305e631d212536087e0703da5cfaa0b" => :mavericks
    sha256 "7e67102cf8e877695ab62fdd8af1975345a4761b860a3ab991b3aa3b1087fec1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "msgpack"
  depends_on "mecab" => :optional
  depends_on "mecab-ipadic" if build.with? "mecab"
  depends_on "lz4" => :optional
  depends_on "openssl"

  depends_on "glib" if build.include? "enable-benchmark"

  option "enable-benchmark", "Enable benchmark program for developer use"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib
      --disable-zeromq
      --enable-mruby
      --without-libstemmer
    ]

    args << "--enable-benchmark" if build.include? "enable-benchmark"
    args << "--with-mecab" if build.with? "mecab"
    args << "--with-lz4" if build.with? "lz4"

    # ZeroMQ is an optional dependency that will be auto-detected unless we disable it
    system "./configure", *args
    system "make"
    system "make install"
  end
end
