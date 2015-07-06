class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.5.tar.gz"
  sha256 "ca62d15374117f4007a7b406ac2072683edda7ed7607d1b1fbcf3a30920f5b56"

  bottle do
    sha256 "0e4834e388e1e485527c0fd89cde6a61de679fc5873f05cd0d21be93baf9a17c" => :yosemite
    sha256 "e387a4528bc4ae8069570e08d4ab7e7171e410f314972ce1574f585e4552b957" => :mavericks
    sha256 "2c431bda2806787342854e84fdb284d7e20f3ca04d28d72f7875f640cd8f5564" => :mountain_lion
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
