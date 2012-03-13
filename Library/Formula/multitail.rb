require 'formula'

class Multitail < Formula
  url 'http://www.vanheusden.com/multitail/multitail-5.2.8.tgz'
  homepage 'http://www.vanheusden.com/multitail/download.html'
  md5 'aaa3691b0ea66ef02ffefd628c7dee8b'

  def install
    system "env", "DESTDIR=#{prefix}", "make", "-f", "makefile.macosx", "multitail"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end
end
