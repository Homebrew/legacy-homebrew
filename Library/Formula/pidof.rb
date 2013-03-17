require 'formula'

class Pidof < Formula
  homepage 'http://www.nightproductions.net/cli.htm'
  url 'http://www.nightproductions.net/downloads/pidof_source.tar.gz'
  sha1 '150ff344d7065ecf9bc5cb3c2cc83eeda8d31348'
  version '0.1.4'

  bottle do
    cellar :any
    revision 1
    sha1 'da148135814b86ac578de9d0b19f1f2deda0a312' => :mountain_lion
    sha1 'e818806883c83e6315d68fc93a37071c90c9f2ea' => :lion
    sha1 '6b950109d55d192d6e95dd23912ecb13ffa2e94f' => :snow_leopard
  end

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end
end
