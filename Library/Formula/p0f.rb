require 'formula'

class P0f < Formula
  url 'http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.02b.tgz'
  homepage 'http://lcamtuf.coredump.cx/p0f3/'
  md5 '062ac4c410f7ec49434872efe322c880'

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install ["p0f"]
    (etc+"p0f").install ['p0f.fp']
  end
end
