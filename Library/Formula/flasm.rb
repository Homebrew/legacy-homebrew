require 'formula'

class Flasm < Formula
  homepage 'http://www.nowrap.de/flasm.html'
  url 'http://www.nowrap.de/download/flasm16src.zip'
  md5 '28a4586409061b385d1cd27d3f120c0b'
  version '1.62'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "flasm"
  end
end
