require 'formula'

class Expm < Formula
  homepage 'http://expm.co'
  url      'http://expm.co/__download__/expm', :using => :nounzip
  sha1     'ddc367daa3d725900e065974d9e0b0fe40ef53e5'
  version  '0.1'

  def install
    bin.install('expm')
  end

  def test
    system "expm version"
  end
end

