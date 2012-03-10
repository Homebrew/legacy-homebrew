require 'formula'

class ShaperProbe < Formula
  url 'http://www.cc.gatech.edu/~partha/diffprobe/shaperprobe.tgz'
  homepage 'http://www.cc.gatech.edu/~partha/diffprobe/shaperprobe.html'
  md5 'a15b31cce3ffe087c5242d1fc9006c13'
  version '2009.10'

  def install
    system "make -f Makefile.osx"
    bin.install "prober"
  end
end
