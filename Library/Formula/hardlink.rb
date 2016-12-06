require 'formula'

class Hardlink < Formula
  homepage 'http://jak-linux.org/projects/hardlink'
  url 'http://jak-linux.org/projects/hardlink/hardlink_0.1.2.tar.gz'
  md5 '9c5a71b46a86cd292f922071c90452e1'

  def install
    system "ln hardlink.py hardlink"
    bin.install "hardlink"
    man1.install gzip('hardlink.1')
  end

  def test
    system "#{bin}/hardlink --version"
  end

end

