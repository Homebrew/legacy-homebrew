require 'formula'

class WaitOn < Formula
  homepage 'http://www.freshports.org/sysutils/wait_on/'
  url 'ftp://ftp.ugh.net.au/pub/unix/wait_on/wait_on-1.1.tar.gz'
  md5 '6b5917ad6136fdd8295d2d1299db10d5'

  def install
    system "/usr/bin/bsdmake"
    bin.install 'wait_on'
    man1.install 'wait_on.1.gz'
  end

  def test
    system "wait_on -v"
  end
end
