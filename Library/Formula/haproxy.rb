class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.6/src/haproxy-1.6.2.tar.gz"
  sha256 "bd4a7eee79e1bfd25af59d956bb60e82acbb6f146f3fb3b30636036f4c9548d3"

  bottle do
    cellar :any
    sha256 "6f015f42e4157bb98c501af6872f2e9f1a820a9003ed19e5d3797da9e579069f" => :el_capitan
    sha256 "bd4bf6a9b565f6d784ff982a55102bd8caafedcd3d558411ee9285e9222583b2" => :yosemite
    sha256 "89fdf17cbcc9110e5cc6d2a2e3110d39f892050f968c9e5fb46ce0adc7077fda" => :mavericks
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
