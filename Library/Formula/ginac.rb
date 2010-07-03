require 'formula'

class Ginac <Formula
  url 'http://www.ginac.de/ginac-1.5.7.tar.bz2'
  homepage 'http://www.ginac.de/'
  md5 '6714dc642dec79fed35b9ba7b7a83b0a'

  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
