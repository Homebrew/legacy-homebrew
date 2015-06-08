class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.4.tar.gz"
  sha256 "338b7a921e6f6dcf3e65d2147a55a9fe646544eeb97653194261111159b4fe10"

  bottle do
    sha256 "73dd96e27fcc896f7625fb834f4869ed515c97a41213ceb06c35c379e45a2bfc" => :yosemite
    sha256 "a79bacfd254ef168aa2f20d116bd6f3ed207cf17b7a7b9a9d8a15b0fa79e861f" => :mavericks
    sha256 "5d7041fac2246ffda0a056e86a03a8e49eef6617f06dfda6ee1c1e709bb9c09c" => :mountain_lion
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
