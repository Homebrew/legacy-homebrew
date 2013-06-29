require 'formula'

class Haproxy < Formula
  homepage 'http://haproxy.1wt.eu'
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.23.tar.gz'
  sha1 'a171a98e58a853e6487ff768db53a496012fd704'

  devel do
    url 'http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev19.tar.gz'
    sha1 '5c16686c516dbeaab8ada6c17c25e9629ab4f7d3'
    version '1.5-dev19'
  end

  depends_on 'pcre'

  def install
    args = ["TARGET=generic",
            "USE_KQUEUE=1",
            "USE_POLL=1",
            "USE_PCRE=1"]

    if build.devel?
      args << "USE_OPENSSL=1"
      args << "ADDLIB=-lcrypto"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end
end
