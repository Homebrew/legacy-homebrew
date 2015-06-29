class Czmq < Formula
  desc "High-level C binding for ZeroMQ"
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-3.0.2.tar.gz"
  sha256 "8bca39ab69375fa4e981daf87b3feae85384d5b40cef6adbe9d5eb063357699a"

  bottle do
    cellar :any
    sha256 "85e90046efe9bfb89c6cd94dcab7869673bffebff31eef220d493020fdf45f88" => :yosemite
    sha256 "f6adffe6da23c90632ad57cfedcf3b6725ea5eda506714518981e5571a6d1ee7" => :mavericks
    sha256 "71313a3a187fe0fbd7accf221658819f736a93bb86fad8fac18d700399fd5d3d" => :mountain_lion
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
  end
end
