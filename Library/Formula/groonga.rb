class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-5.0.1.tar.gz"
  sha1 "3275dd03a09ccaf11c86a70477191a9f5bec0efb"

  # These patches fixes Groonga build failure issue:
  # https://github.com/groonga/groonga/issues/328
  patch do
    url "https://github.com/groonga/groonga/commit/d58895c5d7119c3c64e1e578e0f8ec7ce24c17a5.diff"
    sha1 "ffd8e67ea3070db77e0f6551791c8ab7ad3eada2"
  end

  patch do
    url "https://github.com/groonga/groonga/commit/bde9b688590274621074ef5848ba13499ebc1e60.diff"
    sha1 "dd488c4a5757c14032c7958b36b8323f17b50169"
  end

  patch do
    url "https://github.com/groonga/groonga/commit/a6b65beca50893214f3452a356983e337e14a3eb.diff"
    sha1 "893f7d656cbcacc9e7b7aed21d732fef65b9e25d"
  end

  patch do
    url "https://github.com/groonga/groonga/commit/50dbef3013bb0ee073ba0d6fdfbbdab2fa184802.diff"
    sha1 "446af21f7a24675403411cfc50c86e2bfa2aed32"
  end

  patch do
    url "https://github.com/groonga/groonga/commit/3946c76191e86b0ccde663dd4ffdc77e67376b2d.diff"
    sha1 "3c5931a408b67163275529843bba5f8a7284e88c"
  end

  bottle do
    sha1 "2fdf891db87a18d16a6957ce4578456e86e6c8ec" => :yosemite
    sha1 "15b4d1ee1571f4837d78fb6a5ac17febb9f31a0f" => :mavericks
    sha1 "5383235d638b0ede0970c2343e8cae44e7858949" => :mountain_lion
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
