require "formula"

class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-4.0.4.tar.gz"
  sha1 "47c874beb84fcb1c5420a5cb1d1da1441464dcbb"

  bottle do
    sha1 "457bd21e361f3f60442f924cb0053e960baa83ce" => :mavericks
    sha1 "0c3a36b9bad2f5708abbd85542245d113ec68b17" => :mountain_lion
    sha1 "849a0030a19683cdb881d84de39f4510ae63354f" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "msgpack"
  depends_on "mecab" => :optional
  depends_on "mecab-ipadic" if build.with? "mecab"

  depends_on "glib" if build.include? "enable-benchmark"

  option "enable-benchmark", "Enable benchmark program for developer use"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib
      --disable-zeromq
    ]

    args << "--enable-benchmark" if build.include? "enable-benchmark"
    args << "--with-mecab" if build.with? "mecab"

    # ZeroMQ is an optional dependency that will be auto-detected unless we disable it
    system "./configure", *args
    system "make install"
  end
end
