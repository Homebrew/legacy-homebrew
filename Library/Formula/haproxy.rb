require 'formula'

class Haproxy < Formula
  homepage 'http://haproxy.1wt.eu'
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.17.tar.gz'
  md5 '7f82319fdb53956b14f2088b654be341'

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
