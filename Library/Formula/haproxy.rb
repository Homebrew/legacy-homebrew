require "formula"

class Haproxy < Formula
  homepage "http://haproxy.1wt.eu"
  url "http://www.haproxy.org/download/1.5/src/haproxy-1.5.9.tar.gz"
  sha1 "62620311db4b18f10464ffcbcc0398161f5c8a6b"

  depends_on "pcre"

  def install
    args = ["TARGET=generic",
            "USE_KQUEUE=1",
            "USE_POLL=1",
            "USE_PCRE=1",
            "USE_OPENSSL=1",
            "USE_ZLIB=1",
            "ADDLIB=-lcrypto",
    ]

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end
end
