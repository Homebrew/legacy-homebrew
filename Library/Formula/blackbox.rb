require 'formula'

class Blackbox < Formula
  url 'http://www.cs.rochester.edu/u/kautz/satplan/blackbox/Blackbox44.tgz'
  homepage 'http://www.cs.rochester.edu/u/kautz/satplan/blackbox/'
  md5 'b11aca3c49eb63b2b914b689c2a89dec'

  def install
    system "make"
    bin.install 'blackbox'
  end

  def test
    system "blackbox"
  end
end
