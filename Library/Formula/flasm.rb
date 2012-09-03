require 'formula'

class Flasm < Formula
  homepage 'http://www.nowrap.de/flasm.html'
  url 'http://www.nowrap.de/download/flasm16src.zip'
  sha1 '3b383fa042eae414c5e5608bfa91a42f44bd1a86'
  version '1.62'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "flasm"
  end
end
