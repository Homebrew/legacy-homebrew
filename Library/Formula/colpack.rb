require 'formula'

class Colpack < Formula
  homepage 'http://www.cscapes.org/coloringpage/software.htm'
  url 'http://www.cscapes.org/download/ColPack/ColPack-1.0.6.tar.gz'
  sha1 '4be7e9e818e0c72fc8c72e29b1898d6dd46348aa'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
