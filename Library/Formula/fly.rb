require 'formula'

class Fly < Formula  
  homepage 'http://evolve2k.github.com/fly'
  url 'https://github.com/evolve2k/fly/tarball/1.0'
  sha1 'b4efe0085d72a855d917e0820e1ab16193489455'

  def install
    bin.install 'fly'
  end

  def test
    system 'fly'
  end
end
