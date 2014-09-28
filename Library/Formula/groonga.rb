require "formula"

class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-4.0.6.tar.gz"
  sha1 "1ba7431cfca58dba7f5484d2c8013f24f6d8a322"

  bottle do
    sha1 "9c6ab2a1c81cf907cadfb0a48a66a326737091b9" => :mavericks
    sha1 "c39d70c9ae83fd3af14079d0102391cf4b7649bb" => :mountain_lion
    sha1 "d46e6f5df48d56b653b8fe183b1caf83634e128b" => :lion
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
