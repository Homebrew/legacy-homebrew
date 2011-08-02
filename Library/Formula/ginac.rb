require 'formula'

class Ginac < Formula
  url 'http://www.ginac.de/ginac-1.6.0.tar.bz2'
  homepage 'http://www.ginac.de/'
  md5 '6d1385b440c00705a368ad51d60a292d'

  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
