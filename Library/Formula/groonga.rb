require "formula"

class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.0.tar.gz"
  sha1 "f9786f540c65afcc1da13cc48317e51c81b38eb1"

  bottle do
    sha1 "2fdf891db87a18d16a6957ce4578456e86e6c8ec" => :yosemite
    sha1 "15b4d1ee1571f4837d78fb6a5ac17febb9f31a0f" => :mavericks
    sha1 "5383235d638b0ede0970c2343e8cae44e7858949" => :mountain_lion
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
