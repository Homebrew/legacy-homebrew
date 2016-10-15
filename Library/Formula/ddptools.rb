require 'formula'

class Ddptools < Formula
  homepage 'http://ddp.andreasruge.de'
  url 'http://ddp.andreasruge.de/dist/ddptools-0.8.7a-osx.tar.gz'
  sha1 'ff062d302d55ee2880b957f6e802b0b503d3ead9'

  def install
    bin.install ['ddpinfo', 'cue2ddp', 'cdtinfo']
    man1.install ['doc/ddpinfo.1', 'doc/cue2ddp.1', 'doc/cdtinfo.1']
  end

  test do
    system "#{bin}/ddpinfo", "--version"
    system "#{bin}/cue2ddp", "--version"
    system "#{bin}/cdtinfo", "--version"
  end

end
