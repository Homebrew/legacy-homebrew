require 'formula'

class Csup < Formula
  url 'http://mu.org/~mux/csup-snap-20060318.tgz'
  homepage 'http://mu.org/~mux/csup.html'
  md5 '9218f06f13ed28d1086eec413a734915'

  def install
    system "make"
    bin.install "csup"
    man1.install "csup.1"
  end

  def test
    system "csup -v"
  end
end
