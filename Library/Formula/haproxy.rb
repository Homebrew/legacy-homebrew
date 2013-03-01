require 'formula'

class Haproxy < Formula
  homepage 'http://haproxy.1wt.eu'
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.22.tar.gz'
  sha1 'ed8918c950bdb5b4b96d62c23073b7972443fe94'

  devel do
    url 'http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev17.tar.gz'
    sha1 '0a11803fc7a1b313f56e5a989cbaad7cec6ddcf1'
    version '1.5-dev17'
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
