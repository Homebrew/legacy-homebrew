require 'formula'

class Pwnat < Formula
  url 'http://samy.pl/pwnat/pwnat-0.3-beta.tgz'
  homepage 'http://samy.pl/pwnat/'
  md5 'd1f2b556a32669484f0358d009a20feb'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=-lz"
    bin.install "pwnat"
  end
end
