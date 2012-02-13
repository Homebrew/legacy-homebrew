require 'formula'

class Agrep < Formula
  homepage 'http://en.wikipedia.org/wiki/Agrep'
  url 'ftp://ftp.cs.arizona.edu/agrep/agrep-2.04.tar.Z'
  md5 'abc645404d3926a57c3f5e86a6e89ee9'

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install "agrep"
    man1.install "agrep.1"
  end
end
