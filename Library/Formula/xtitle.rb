require 'formula'

class Xtitle < Formula
  homepage 'http://www.cs.indiana.edu/~kinzler/xtitle'
  url 'http://www.cs.indiana.edu/~kinzler/xtitle/xtitle-1.0.2.tgz'
  version '1.0.2'
  sha1 '0322cf93316a066bcba098b250821bcadaaedc02'

  def install
    File.rename "xtitle.sh", "xtitle"
    File.rename "xtitle.man", "xtitle.1"
  
    bin.install 'xtitle'
    man1.install 'xtitle.1'
  end
end
