class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-3.0.2.tar.gz"
  sha256 "8bca39ab69375fa4e981daf87b3feae85384d5b40cef6adbe9d5eb063357699a"
  revision 1

  bottle do
    cellar :any
    sha256 "936bd015196746bccb8cf3282564333f1d2bec0b42c509415b56c7ee89104506" => :el_capitan
    sha256 "cb5e7a40b945b014c92597ce275b76f5a39541e0f96e6ea541cb0d6e706bcfaa" => :yosemite
    sha256 "42f0561a90ba0d17d17477282a2c2cc3f36ed72eb37209114626f51565852948" => :mavericks
    sha256 "1b6ecec3b74fb846b025c6da0ae28820569e542eee55c80658c2074a8d2ada87" => :mountain_lion
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
    args << "--with-libsodium" if build.with? "libsodium"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]

    # makecert clashes with Mono. Rename it less generically.
    mv bin/"makecert", bin/"czmq-makecert"
  end
end
