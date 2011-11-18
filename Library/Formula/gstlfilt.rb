require 'formula'

class Gstlfilt < Formula
  url 'http://www.bdsoft.com/dist/gstlfilt.tar'
  md5 'bb0081d0bb2e5a24afaf16ed3cf897b9'
  version '3.10'

  def install
    system 'tar xvf gstlfilt.tar'
    inreplace 'gfilt', 'COMPILER=c++', 'COMPILER=g++'
    bin.install('gfilt')
    bin.install('gSTLFilt.pl')
  end

  def test
    system 'gfilt'
  end
end
