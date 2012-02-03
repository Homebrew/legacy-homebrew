require 'formula'

class Fmscripts < Formula
  url 'http://www.defraine.net/~brunod/fmdiff/fmscripts-20110714.tar.gz'
  homepage 'http://soft.vub.ac.be/soft/'
  md5 '54b5ed94c89acd309effd37187414593'

  def install
    bin.install ['fmdiff', 'fmdiff3', 'fmmerge', 'fmresolve']
  end

  def test
    system "/usr/local/bin/fmdiff"
    system "/usr/local/bin/fmdiff3"
    system "/usr/local/bin/fmmerge"
    system "/usr/local/bin/fmresolve"
  end
end
