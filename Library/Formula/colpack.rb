require 'formula'

class Colpack < Formula
  homepage 'http://www.cscapes.org/coloringpage/software.htm'
  url 'http://www.cscapes.org/download/ColPack/ColPack-1.0.7.tar.gz'
  sha1 '522c0c9761774f59669144f2203fe8a59fc9fe8f'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
