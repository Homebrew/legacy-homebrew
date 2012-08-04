require 'formula'

class Fmdiff < Formula
  homepage 'http://www.defraine.net/~brunod/fmdiff/'
  url 'http://www.defraine.net/~brunod/fmdiff/fmscripts-20120522.tar.gz'
  sha1 'cdb98c68b617c8b42e714a906b7f3824c4c5afe9'

  head 'http://soft.vub.ac.be/svn-gen/bdefrain/fmscripts/'

  def install
    bin.install Dir["fm*"]
  end
end
