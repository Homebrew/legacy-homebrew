class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.5/src/haproxy-1.5.12.tar.gz"
  sha256 "6648dd7d6b958d83dd7101eab5792178212a66c884bec0ebcd8abc39df83bb78"

  bottle do
    cellar :any
    sha256 "54186ef7f1bcb8b4941fde67f7750be624330eadb742621426c99555fd9f80d0" => :yosemite
    sha256 "07bb7176d3a17cf3b8e3d4c4c41270222b4ba64f6356bb8d995850ad5c4b6812" => :mavericks
    sha256 "659b784880a552de4cb8206900ad0eca5e3505644dc1e4e8e3fcb3f4d6d6f24f" => :mountain_lion
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
