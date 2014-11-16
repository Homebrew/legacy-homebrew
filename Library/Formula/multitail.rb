require 'formula'

class Multitail < Formula
  homepage 'http://www.vanheusden.com/multitail/download.html'
  url 'http://www.vanheusden.com/multitail/multitail-6.2.1.tgz'
  sha1 '30bd77c4f542cd6ad6f1a0351f7d9e0a6cef6585'

  def install
    ENV['DESTDIR'] = prefix
    system "make", "-f", "makefile.macosx", "multitail"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end
end
