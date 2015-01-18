require "formula"

class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-4.1.0.tar.gz"
  sha1 "186a2fd7c1634bce6a9a0c2629eaf7e486d1e56c"

  bottle do
    revision 1
    sha1 "34746158c1739ae41e05197b9a0ae1591a903572" => :yosemite
    sha1 "6f04fa4f84f2cdbb09d696133fbd16a71e20bc8e" => :mavericks
    sha1 "29d79dcc357ebcf19645522d5d85ff5852f80859" => :mountain_lion
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
