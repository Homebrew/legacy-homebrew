require 'formula'

class Haproxy < Formula
  homepage 'http://haproxy.1wt.eu'
  url 'http://www.haproxy.org/download/1.5/src/haproxy-1.5.0.tar.gz'
  sha1 'dc957d93871e4543d1850a144543bcaa26df37a0'

  bottle do
    cellar :any
    sha1 "22967377181e7ead7e4a933be2744d7af697823e" => :mavericks
    sha1 "2092512c8b99f7165cb7207059626bda6d966259" => :mountain_lion
    sha1 "a99d9d7d867fd97df7b75b338b995d7be69fd8d1" => :lion
  end

  depends_on 'pcre'

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
