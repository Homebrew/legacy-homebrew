class Haproxy < Formula
  homepage "http://haproxy.1wt.eu"
  url "http://www.haproxy.org/download/1.5/src/haproxy-1.5.12.tar.gz"
  sha256 "6648dd7d6b958d83dd7101eab5792178212a66c884bec0ebcd8abc39df83bb78"

  bottle do
    cellar :any
    sha1 "6c80304f8eace5073797f04646ef197099ce39d4" => :yosemite
    sha1 "3fdaeaae9c33cc73e7314cd4844b46b82572706b" => :mavericks
    sha1 "c42557822dcf88fdc74d0090e50358d254db7509" => :mountain_lion
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
