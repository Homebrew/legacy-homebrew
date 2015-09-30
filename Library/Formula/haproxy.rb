class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.5/src/haproxy-1.5.14.tar.gz"
  sha256 "9565dd38649064d0350a2883fa81ccfe92eb17dcda457ebdc01535e1ab0c8f99"

  bottle do
    cellar :any
    sha256 "0f74dd1eab5f74db336b8b4853a849769588dd6777a2a56acd59d11cba5dbc8c" => :el_capitan
    sha256 "54369189f1b23ee7240f82b1277293eae6fd583cbed0fc3c43f344477149f1a6" => :yosemite
    sha256 "cc7b5f2b2a2eea08f7b78a15074fcccfa2c1a7e901ffda301ede6a2c479a1fbc" => :mavericks
    sha256 "9695138dd5bd45cee081720f2ba0791c4f5fdfedf43d883770531c40eefa8377" => :mountain_lion
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
