require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url "http://packages.groonga.org/source/groonga/groonga-4.0.3.tar.gz"
  sha1 "f5ed68228e82585903f672f3387785b3b7e24dea"

  bottle do
    sha1 "98657e13f9e3c1f5f4c07b33fce4e177a509f021" => :mavericks
    sha1 "68a0527f07618bae86bf5f57197046bc63f02cba" => :mountain_lion
    sha1 "2908fc043a05ec6928b718ba2a8e35ff8761b0b8" => :lion
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
