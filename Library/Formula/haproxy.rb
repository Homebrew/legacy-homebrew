class Haproxy < Formula
  homepage "http://haproxy.1wt.eu"
  url "http://www.haproxy.org/download/1.5/src/haproxy-1.5.10.tar.gz"
  sha1 "2af3b740e84f10cbd0c90a78c30a222a24fb2945"

  bottle do
    cellar :any
    sha1 "6de94b8c47b778d9384a688b1ac035c9cc99cdd8" => :yosemite
    sha1 "ac3bd5ee5d46f895bde4fb3d7a236b94dbe9eb21" => :mavericks
    sha1 "6b3b5697ebc10921e38db161dcdc59cb3053ae3d" => :mountain_lion
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
