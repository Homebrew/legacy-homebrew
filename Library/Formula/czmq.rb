class Czmq < Formula
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-2.2.0.tar.gz"
  sha1 "2f4fd8de4cf04a68a8f6e88ea7657d8068f472d2"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "798cef5fd0d7c79123fe60be9db628e8db5fe351" => :yosemite
    sha1 "c1361edaea2bbea8f30937741b5346e419c3909c" => :mavericks
    sha1 "9a8556182c8599cf1a32f0cec8e6dc8eed151035" => :mountain_lion
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
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end

  test do
    bin.cd do
      system "#{bin}/czmq_selftest"
    end
  end
end
