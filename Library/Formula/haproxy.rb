class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.6/src/haproxy-1.6.3.tar.gz"
  sha256 "fd06b45054cde2c69cb3322dfdd8a4bcfc46eb9d0c4b36d20d3ea19d84e338a7"

  bottle do
    cellar :any
    sha256 "448c61867c1444b29e197cfeed3a0b9ce9c5a55251cfd41f209d4d15bfcac798" => :el_capitan
    sha256 "bfe64be6c088ea06d02958210459a40b49fb09cec6af490b1c7b64e1d9adcd89" => :yosemite
    sha256 "0f782be159de5ecb138d93fdeb92c5ff3a867df1006a468c965883a7ef73c17a" => :mavericks
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
