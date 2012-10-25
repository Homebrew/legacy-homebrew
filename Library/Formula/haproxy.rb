require 'formula'

class Haproxy < Formula
  homepage 'http://haproxy.1wt.eu'
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.22.tar.gz'
  sha1 'ed8918c950bdb5b4b96d62c23073b7972443fe94'

  depends_on 'pcre'

  def install
    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "TARGET=generic",
                   "USE_KQUEUE=1",
                   "USE_POLL=1",
                   "USE_PCRE=1",
                   "PREFIX=#{prefix}",
                   "DOCDIR=#{doc}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end
end
