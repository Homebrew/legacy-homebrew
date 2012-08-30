require 'formula'

class P0f < Formula
  homepage 'http://lcamtuf.coredump.cx/p0f3/'
  url 'http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.05b.tgz'
  sha1 'e6f39c3811e681272e772f33588aa46b75975708'

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc+"p0f").install "p0f.fp"
  end
end
