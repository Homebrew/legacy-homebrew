require 'formula'

class TaskSpooler < Formula
  homepage 'http://vicerveza.homeunix.net/~viric/soft/ts/'
  url 'http://vicerveza.homeunix.net/~viric/soft/ts/ts-0.7.3.tar.gz'
  version '0.7.3'
  sha1 '33b9321d4f48a2c2685a8240db4e00c0e69ef9bc'

  def install
    system "make install"
  end

  def test
    system "ts"
  end
end
