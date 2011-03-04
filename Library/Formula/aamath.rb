require 'formula'

class Aamath <Formula
  url 'http://fuse.superglue.se/aamath/aamath-0.3.tar.gz'
  homepage 'http://fuse.superglue.se/aamath/'
  md5 'f0e835bd06069b1bdaddd9e9c3447c12'

  def install
    system "make -j1"
    bin.install "aamath"
    prefix.install "testcases"
    man1.install "aamath.1"
  end
end
