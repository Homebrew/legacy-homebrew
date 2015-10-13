class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.8.tar.gz"
  sha256 "9bc8aca52842a90cbeeb816a2a8ad9c89b226c14fca4c18661039e54587a5a29"

  bottle do
    sha256 "696fa3bede74506be0a48cb3922c4b8b892bb2ef7422ffb23674658f5a42f51b" => :el_capitan
    sha256 "ccca48f11abdb8fc0179c4fd551b5dd09f985c2c2124fbaeef265c806fc11c19" => :yosemite
    sha256 "97f66a1f7d66d8d53396af2bb918afef2f4706da4d091d4b4db479c9ee7daf3d" => :mavericks
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
