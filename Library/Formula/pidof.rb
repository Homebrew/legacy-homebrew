require 'formula'

class Pidof < Formula
  homepage 'http://www.nightproductions.net/cli.htm'
  url 'http://www.nightproductions.net/downloads/pidof_source.tar.gz'
  sha1 '150ff344d7065ecf9bc5cb3c2cc83eeda8d31348'
  version '0.1.4'

  bottle do
    sha1 '77c1d4049ffb4ec5eabb25c04ac916c2a74b7fc3' => :mountainlion
    sha1 '55132e9ded5e165405777ba4a5b97b41ca476fc9' => :lion
    sha1 'e43a932c884f17e71b00ac3b76c44bd51af285fe' => :snowleopard
  end

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end
end
