require 'formula'

class Rawk < Formula
  homepage 'http://rawk.brokenlcd.net'
  url 'http://downloads.sourceforge.net/project/rawk-sh/rawk-1.0.tgz'
  md5 'aa1c4a5c742ae561302fe76b192f1244'

  def install
    system "make PREFIX=#{prefix}"
  end

  def test
    system "true"
  end
end
