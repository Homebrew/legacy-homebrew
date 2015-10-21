class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.6/src/haproxy-1.6.0.tar.gz"
  sha256 "e83a272b7d3638cf1d37bba58d3e75f497c1862315ee5bb7f5efc1d98d26e25b"

  bottle do
    cellar :any
    sha256 "7b5b243e98d102fcbf6da80d3b16f913756bd33c43c7577a82e1179ebfcbc35d" => :el_capitan
    sha256 "0cae5e75a60a81617e6dabf8aa1faef1272d7cd62dd6e1c5443d76269ae234bb" => :yosemite
    sha256 "51286195327b812b337b916d14ff79682cdd71508313536f25a292bbf668e86b" => :mavericks
  end

  depends_on "openssl"
  depends_on "pcre"

  def install
    args = %w[
      TARGET=generic
      USE_KQUEUE=1
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  test do
    system bin/"haproxy", "-v"
  end
end
