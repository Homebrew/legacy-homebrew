class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.7.tar.gz"
  sha256 "f0f148916179993b22c14f914f148fd9bad3163071b106a36251e92a3869b710"

  bottle do
    sha256 "8d6f96fb3bf2212916e0bf0dcb4af23983b6f89fe0c29f553a03fcb76e4bfc31" => :yosemite
    sha256 "02681009cdcfbad7c085380277706c8d3391ff9949c63f129135dfebdd015a4b" => :mavericks
    sha256 "c5b2b8d400696df717b19d149ebd75a9407b19c96f7fa70863d5cbc1b49f0134" => :mountain_lion
  end

  option "with-benchmark", "With benchmark program for developer use"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "msgpack"
  depends_on "mecab" => :optional
  depends_on "mecab-ipadic" if build.with? "mecab"
  depends_on "lz4" => :optional
  depends_on "openssl"

  depends_on "glib" if build.with? "benchmark"

  deprecated_option "enable-benchmark" => "with-benchmark"

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
    system "make", "install"
  end

  test do
    output = shell_output("groonga --version")
    assert_match /groonga #{version}/, output
  end
end
