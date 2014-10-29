require "formula"

class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-4.0.7.tar.gz"
  sha1 "b00c56c6d7318fe1a87f6f55366182ace4014a2a"

  bottle do
    sha1 "93dd670108b2ef9f219827eed3e158c4a8f6a4f6" => :mavericks
    sha1 "1986c599bf78578a148e19cb293079702ab0ee5d" => :mountain_lion
    sha1 "3fa6aa3b485d1395e3e54136868f4ae662b3114f" => :lion
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
      --with-mruby
      --without-libstemmer
    ]

    args << "--enable-benchmark" if build.include? "enable-benchmark"
    args << "--with-mecab" if build.with? "mecab"
    args << "--with-lz4" if build.with? "lz4"

    # ZeroMQ is an optional dependency that will be auto-detected unless we disable it
    system "./configure", *args
    system "make install"
  end
end
