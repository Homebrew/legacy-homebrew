require 'formula'

class Haproxy < Formula
  homepage 'http://haproxy.1wt.eu'
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.20.tar.gz'
  md5 '0cd3b91812ff31ae09ec4ace6355e29e'

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
