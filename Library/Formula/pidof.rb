require 'formula'

class Pidof < Formula
  homepage 'http://www.nightproductions.net/cli.htm'
  url 'http://www.nightproductions.net/downloads/pidof_source.tar.gz'
  sha1 '150ff344d7065ecf9bc5cb3c2cc83eeda8d31348'
  version '0.1.4'

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end
end
