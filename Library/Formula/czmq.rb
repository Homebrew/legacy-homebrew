require "formula"

class Czmq < Formula
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-2.2.0.tar.gz"
  sha1 "2f4fd8de4cf04a68a8f6e88ea7657d8068f472d2"
  revision 1

  bottle do
    cellar :any
    sha1 "76953cbf02d8eb56aa0bea5caefa19d19f5e48c6" => :yosemite
    sha1 "5297d31b43353db09cc1931de2a529999ca0f2b5" => :mavericks
    sha1 "998759fe30f0e27fb994130dd7fe95c5930a8124" => :mountain_lion
  end

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "zeromq"
  depends_on "libsodium" => :recommended

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    if build.stable?
      args << "--with-libsodium" if build.with? "libsodium"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end

  test do
    bin.cd do
      system "#{bin}/czmq_selftest"
    end
  end
end
