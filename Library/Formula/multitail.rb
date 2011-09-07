require 'formula'

class Multitail < Formula
  url 'http://www.vanheusden.com/multitail/multitail-5.2.6.tgz'
  homepage 'http://www.vanheusden.com/multitail/download.html'
  md5 '6496b3d78660ff8d11c743a0d03cca34'

  def install
    system "env", "DESTDIR=#{prefix}", "make", "-f", "makefile.macosx", "multitail"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end
end
