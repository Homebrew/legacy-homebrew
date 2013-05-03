require 'formula'

class Sersniff < Formula
  homepage 'http://www.earth.li/projectpurple/progs/sersniff.html'
  url 'http://www.earth.li/projectpurple/files/sersniff-0.0.5.tar.gz'
  sha1 'f320171e38ce8877646be65664328071254ed3ce'

  head 'git://the.earth.li/sersniff'

  def install
    system "make"
    bin.install "sersniff"
    man8.install "sersniff.8"
  end
end
