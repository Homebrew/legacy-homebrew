require 'formula'

class ShaperProbe < Formula
  homepage 'http://www.cc.gatech.edu/~partha/diffprobe/shaperprobe.html'
  url 'http://www.cc.gatech.edu/~partha/diffprobe/shaperprobe.tgz'
  sha1 '91e06ad4e1e966f15b887243c276cb12107baf0f'
  version '2012.01'

  def install
    system "make -f Makefile.osx"
    bin.install "prober"
  end
end
