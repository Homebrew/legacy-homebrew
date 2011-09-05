require 'formula'

class Sersniff < Formula
  url 'http://www.earth.li/projectpurple/files/sersniff-0.0.5.tar.gz'
  homepage 'http://www.earth.li/projectpurple/progs/sersniff.html'
  md5 '5caf3262442b5e82c3de820ce3f76fa2'
  head 'git://the.earth.li/sersniff'

  def install
    system "make"
    bin.install "sersniff"
    man8.install "sersniff.8"
  end
end
