class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-3.0.2.tar.gz"
  sha256 "8bca39ab69375fa4e981daf87b3feae85384d5b40cef6adbe9d5eb063357699a"
  revision 2

  bottle do
    cellar :any
    sha256 "3e06ecdf8a59916e5a9db00364c846d494d59afa69db5502b3bf4fe37daa35ac" => :el_capitan
    sha256 "a614cb6f6ad22446ada0acb1988f8e851c3bf6011ade80b688b36b2b846e3abf" => :yosemite
    sha256 "0df3a704f0b7f3eb6e2e2a345cd00d4a87493220db869cfa10dc773325b5ecb9" => :mavericks
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
