require 'formula'

class Pidof < Formula
  url 'http://www.nightproductions.net/downloads/pidof_source.tar.gz'
  homepage 'http://www.nightproductions.net/cli.htm'
  md5 '663763ee1feb0596fa3731aafa7e1880'
  version '0.1.4'

  def install
    system "make all"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end
end
