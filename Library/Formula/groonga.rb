require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-4.0.2.tar.gz'
  sha1 'daa89ac16f00e8cb7f11ebf28cc15dc36a84f4ce'

  bottle do
    sha1 "e39684c9c88a738496ebbcb0ba2e33c21d922043" => :mavericks
    sha1 "7692109f8b2ca457c1ae2a6d7314c24d05cda339" => :mountain_lion
    sha1 "a28d4c0d7de6a8590b8c3a6c1ff0def06485fe84" => :lion
  end

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
