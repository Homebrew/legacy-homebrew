require 'formula'

class Poster < Formula
  url 'https://github.com/schrfr/poster/tarball/1.0.0'
  homepage 'http://schrfr.github.com/poster/'
  md5 'f8fe2420f4f1218861e2fc9a3a57d90b'

  def install
    inreplace "Makefile", "/usr/local/bin", bin
    inreplace "Makefile", "/usr/local/man/man1", man1
    bin.mkpath
    man1.mkpath
    system "make install"
  end

  def test
    return `which poster`.strip != ""
  end

end
