require "formula"

class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-4.0.3.tar.gz"
  sha1 "f5ed68228e82585903f672f3387785b3b7e24dea"

  bottle do
    sha1 "a5de5410b9bf0155a56ad9c5202c401b66139245" => :mavericks
    sha1 "9d182e379145bbfb8ee7c8184ac509e8876b8e29" => :mountain_lion
    sha1 "7c2db670fbc5375e426ef076710d99835835b1f3" => :lion
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
