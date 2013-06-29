require 'formula'

class Multitail < Formula
  homepage 'http://www.vanheusden.com/multitail/download.html'
  url 'http://www.vanheusden.com/multitail/multitail-5.2.12.tgz'
  sha1 '3d4979b8be1daaf99e4fd983366e0131aa3d0d3b'

  def install
    ENV['DESTDIR'] = prefix
    system "make", "-f", "makefile.macosx", "multitail"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end
end
