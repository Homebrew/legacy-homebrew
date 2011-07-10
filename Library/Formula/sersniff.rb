require 'formula'

class Sersniff < Formula
  url 'git://the.earth.li/sersniff'
  homepage 'http://www.earth.li/projectpurple/progs/sersniff.html'
  md5 '5caf3262442b5e82c3de820ce3f76fa2'
  version '0.0.5'

  def install
    system "make"
    bin.install ["sersniff"]
  end
end