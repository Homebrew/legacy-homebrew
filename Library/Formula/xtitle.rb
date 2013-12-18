require 'formula'

class Xtitle < Formula
  homepage 'http://www.cs.indiana.edu/~kinzler/xtitle/'
  url 'http://www.cs.indiana.edu/~kinzler/xtitle/xtitle-1.0.2.tgz'
  sha1 '0322cf93316a066bcba098b250821bcadaaedc02'

  def install
    bin.install "xtitle.sh" => "xtitle"
    man1.install "xtitle.man" => "xtitle.1"
  end
end
