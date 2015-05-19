require 'formula'

class Pidof < Formula
  desc "Display the PID number for a given process name"
  homepage 'http://www.nightproductions.net/cli.htm'
  url 'http://www.nightproductions.net/downloads/pidof_source.tar.gz'
  sha1 '150ff344d7065ecf9bc5cb3c2cc83eeda8d31348'
  version '0.1.4'

  bottle do
    cellar :any
    revision 2
    sha1 '2425268aa94521fbdf20f4ba16b80706a4c737ab' => :mavericks
    sha1 '80a7d45bd8695dbf1594f7626f754038d73551c6' => :mountain_lion
    sha1 'd09a05256afed09c300fd8c908f2559c05f91bce' => :lion
  end

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end
end
