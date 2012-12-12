require 'formula'

class P0f < Formula
  homepage 'http://lcamtuf.coredump.cx/p0f3/'
  url 'http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.06b.tgz'
  sha1 'fecc9ed8b79dbf8e4d5ffbd22eda9d850b42c3c3'

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc+"p0f").install "p0f.fp"
  end
end
