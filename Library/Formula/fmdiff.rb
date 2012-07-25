require 'formula'

class Fmdiff < Formula
  homepage 'http://www.defraine.net/~brunod/fmdiff/'
  url 'http://www.defraine.net/~brunod/fmdiff/fmscripts-20110714.tar.gz'
  md5 '54b5ed94c89acd309effd37187414593'

  head 'http://soft.vub.ac.be/svn-gen/bdefrain/fmscripts/'

  def install
    bin.install Dir["fm*"]
  end
end
