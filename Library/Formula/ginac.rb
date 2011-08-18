require 'formula'

class Ginac < Formula
  url 'http://www.ginac.de/ginac-1.6.1.tar.bz2'
  homepage 'http://www.ginac.de/'
  md5 'd383f3ee50f88ffa1b3966fdb11d0f12'

  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
