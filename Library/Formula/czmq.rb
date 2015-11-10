class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-3.0.2.tar.gz"
  sha256 "8bca39ab69375fa4e981daf87b3feae85384d5b40cef6adbe9d5eb063357699a"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "d3e5623f2c031374d0aecacfa4fff264f290edb1c40a0fa4474daf0098c4b649" => :el_capitan
    sha256 "f0c78d4d93ddcd16f18b6277c39e08b7eb8754c802d2a63c652852613305e4c4" => :yosemite
    sha256 "c9f2bcf72a59b931946945e9661d8f6b43d2ce0f0a18ef8d15db60e830489caf" => :mavericks
  end

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libsodium" => :recommended

  if build.without? "libsodium"
    depends_on "zeromq" => "without-libsodium"
  else
    depends_on "zeromq"
  end

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--with-libsodium" if build.with? "libsodium"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end
end
