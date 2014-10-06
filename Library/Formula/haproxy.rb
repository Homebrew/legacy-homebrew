require "formula"

class Haproxy < Formula
  homepage "http://haproxy.1wt.eu"
  url "http://www.haproxy.org/download/1.5/src/haproxy-1.5.3.tar.gz"
  sha1 "b86c9490dea5bade767d43f544ced383764f879d"

  bottle do
    cellar :any
    sha1 "41d6a7dfd7b72c7f4a4c63c5c35caf1088268a55" => :mavericks
    sha1 "1dbc7bf90ba7742e6f586b4777758547870b099e" => :mountain_lion
    sha1 "5c595b4953060f7a0aa78cc62f8cf1056ec72707" => :lion
  end

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
