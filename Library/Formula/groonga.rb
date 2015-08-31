class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.7.tar.gz"
  sha256 "f0f148916179993b22c14f914f148fd9bad3163071b106a36251e92a3869b710"

  bottle do
    sha256 "2a3f4bda1bb9e950984dec0560e510bed114a640ec08279b75d0e04bccc4ab38" => :yosemite
    sha256 "85fdde9af961eac3113f39e096c3a20bc77f0bbade07b91f81daf372a2c2dd6e" => :mavericks
    sha256 "e5ab452df6b2d7d36f883fe23433a0c286cccf6320888e91de7d83600d391237" => :mountain_lion
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
