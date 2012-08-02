require 'formula'

class Fmdiff < Formula
  homepage 'http://www.defraine.net/~brunod/fmdiff/'
  url 'http://www.defraine.net/~brunod/fmdiff/fmscripts-20120522.tar.gz'
  md5 'c760830c1f67626a9b609cea3338c576'

  head 'http://soft.vub.ac.be/svn-gen/bdefrain/fmscripts/'

  def install
  	system "make"
    bin.install Dir["fm*"]
  end
end
