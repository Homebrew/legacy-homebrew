class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-3.0.1.tar.gz"
  sha1 "fc69f8175347c73a61d2004fc9699f10f8a73eb2"

  bottle do
    cellar :any
    sha256 "87984479649892f23aa2abfebb006606d7e531fea20cade7f12baa7d7462fe43" => :yosemite
    sha256 "9a582534291bc2ec40ebdeba655402f105b6bb17b3c6a3ab98ed9365c7fa5842" => :mavericks
    sha256 "a70dff1acc626c959f25ab2a7ec997b36e1b3261132a0f39fb5851a2f896cdd8" => :mountain_lion
  end

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libsodium" => :optional

  if build.with? "libsodium"
    depends_on "zeromq" => "with-libsodium"
  else
    depends_on "zeromq"
  end

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    if build.stable?
      args << "--with-libsodium" if build.with? "libsodium"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end
end
