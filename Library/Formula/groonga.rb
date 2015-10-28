class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.9.tar.gz"
  sha256 "4fb59009dca154ffb53f9b408dc296e6e215f8eda613a8ef184fa634e702d35d"

  bottle do
    sha256 "69bc0854ee969cd7627f1d7856b5cde5b429b106a298e1673989c83cc1ff3db8" => :el_capitan
    sha256 "a8eab8472f4d58c807441c94f0c2c904241ee918cbb0223defbe743bc1f322e3" => :yosemite
    sha256 "089a97b55ad3733005d3ae5a7f8a9501dfefb0620c1e484e9021ee2bfb438424" => :mavericks
  end

  option "with-benchmark", "With benchmark program for developer use"

  deprecated_option "enable-benchmark" => "with-benchmark"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "msgpack"
  depends_on "mecab" => :optional
  depends_on "lz4" => :optional
  depends_on "openssl"
  depends_on "mecab-ipadic" if build.with? "mecab"
  depends_on "glib" if build.with? "benchmark"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib
      --disable-zeromq
      --enable-mruby
      --without-libstemmer
    ]

    args << "--enable-benchmark" if build.with? "benchmark"
    args << "--with-mecab" if build.with? "mecab"
    args << "--with-lz4" if build.with? "lz4"

    # ZeroMQ is an optional dependency that will be auto-detected unless we disable it
    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("groonga --version")
    assert_match /groonga #{version}/, output
  end
end
