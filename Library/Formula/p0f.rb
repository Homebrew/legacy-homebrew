require 'formula'

class P0f < Formula
  homepage 'http://lcamtuf.coredump.cx/p0f3/'
  url 'http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.05b.tgz'
  md5 'edbc4b135b2646db3227a441268fd2e2'

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc+"p0f").install "p0f.fp"
  end
end
