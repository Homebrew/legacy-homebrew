require 'formula'

class Colpack < Formula
  homepage 'http://www.cscapes.org/coloringpage/software.htm'
  url 'http://cscapes.cs.purdue.edu/download/ColPack/ColPack-1.0.9.tar.gz'
  sha1 'c963424c3e97a7bc3756d3feb742418e89721e48'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
