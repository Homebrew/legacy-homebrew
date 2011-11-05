require 'formula'

class Fmdiff < Formula
  homepage 'http://www.defraine.net/~brunod/fmdiff/'
  head 'http://soft.vub.ac.be/svn-gen/bdefrain/fmscripts/', :using => :svn

  def install
    bin.install Dir["fm*"]
  end
end
