require 'formula'
class Prover9 < Formula
  homepage 'http://www.cs.unm.edu/~mccune/prover9/'
  url 'http://www.cs.unm.edu/~mccune/prover9/download/LADR-2009-11A.tar.gz'
  sha1 '0b30a80f36512c0958b0e77ce18d0d8056e33bb1'
  version '2009-11A'

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make all"
    bin.install Dir['bin/*']
  end

  def test
    system "make test1"
    system "make test2"
    system "make test3"
  end
end
