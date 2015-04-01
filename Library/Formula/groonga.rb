class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.2.tar.gz"
  sha1 "737e2196ea144a7c39ed778c5b748c121128bccf"

  bottle do
    sha256 "25685326a3bb8bb08f24622bec9aa3b892026b4690e28128c3ea1ef804f188d3" => :yosemite
    sha256 "d751e9c1e0afd58a66b9f0e7dc3e488ced59611f00674e9551a899783015ce2b" => :mavericks
    sha256 "ddf57c338f38c5ff227a6709d3ca151250d1600a64cf41e248d0b139c4b03899" => :mountain_lion
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
