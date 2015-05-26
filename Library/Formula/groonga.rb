class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.3.tar.gz"
  sha1 "a3bdc46b980e44dae74dae78777919691cf1b4f0"

  bottle do
    sha256 "f96b7a0ea864c53c672bb9bcbab34976c3ae9fbb1bb5308aa3d4d9aa637821e3" => :yosemite
    sha256 "236f50b9cb5e615e49405168c857cfa5f4859c73b4107b53ecbe9a7b546db8ee" => :mavericks
    sha256 "8c381e70cc24773019bea736ec34a7b8fcdb68c3f54244761616c5b084eea91d" => :mountain_lion
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
