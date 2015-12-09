class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-3.0.2.tar.gz"
  sha256 "8bca39ab69375fa4e981daf87b3feae85384d5b40cef6adbe9d5eb063357699a"
  revision 3

  bottle do
    cellar :any
    sha256 "9bbf6566cd74644ae22f5dd9338c1123bf3ecdf7a920dcaabf166aeb3902e3f7" => :el_capitan
    sha256 "4a569da4e60f3b8252b4ef9a998e50153ac119108135ce832f2494b0edf7e87a" => :yosemite
    sha256 "ae42e5b89ed47c00a3a45d9c3a4759a2f0a772c787f62b34cb024f489790efff" => :mavericks
  end

  conflicts_with "mono", :because => "both install `makecert` binaries"

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
