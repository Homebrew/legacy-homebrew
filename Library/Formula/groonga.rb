require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-4.0.0.tar.gz'
  sha1 '9a64d4c98eda4db563bcaf9464504d24dfdb3ff4'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'msgpack'
  depends_on "mecab" => :optional
  depends_on "mecab-ipadic" if build.with? "mecab"

  depends_on 'glib' if build.include? 'enable-benchmark'

  option 'enable-benchmark', "Enable benchmark program for developer use"

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
