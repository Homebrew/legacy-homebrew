require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-3.1.2.tar.gz'
  sha1 '305ef89b6b9f7e1d55719c2299edad0e10d2d203'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'msgpack'

  depends_on 'glib' if build.include? 'enable-benchmark'
  if build.include? 'with-mecab'
    depends_on 'mecab'
    depends_on 'mecab-ipadic'
  end

  option 'enable-benchmark', "Enable benchmark program for developer use"
  option 'with-mecab', "Enable MeCab tokenizer (TokenMecab)"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib
      --disable-zeromq
    ]

    if build.include? 'enable-benchmark'
      args << '--enable-benchmark'
    end
    if build.include? 'with-mecab'
      args << '--with-mecab'
    end

    # ZeroMQ is an optional dependency that will be auto-detected unless we disable it
    system "./configure", *args
    system "make install"
  end
end
