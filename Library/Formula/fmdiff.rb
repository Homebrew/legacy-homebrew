require 'formula'

class Fmscripts <Formula
  homepage 'http://www.defraine.net/~brunod/fmdiff/'
  url 'http://www.defraine.net/~brunod/fmdiff/fmscripts-20100225.tar.gz'
  md5 'e47366579126d95a8d36b60a9b55127b'
  head 'http://soft.vub.ac.be/svn-gen/bdefrain/fmscripts/', :using => :svn

  def install
    bin.install "fmdiff"
    bin.install "fmdiff3"
    bin.install "fmmerge"
    bin.install "fmresolve"
  end
end
