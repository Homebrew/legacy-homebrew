require 'formula'

class Ginac < Formula
  url 'http://www.ginac.de/ginac-1.6.2.tar.bz2'
  homepage 'http://www.ginac.de/'
  md5 '4cfdd286ab0c32981ec1c9c779e87eb9'

  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
