require 'formula'

class Multitail < Formula
  homepage 'http://www.vanheusden.com/multitail/download.html'
  url 'http://www.vanheusden.com/multitail/multitail-6.0.tgz'
  sha1 'fed0d3c5f03ff022f8f2ae90c0027312c3ff70ce'

  def install
    ENV['DESTDIR'] = prefix
    system "make", "-f", "makefile.macosx", "multitail"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end
end
