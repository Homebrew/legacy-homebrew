require 'formula'

class Ginac < Formula
  url 'http://www.ginac.de/ginac-1.5.8.tar.bz2'
  homepage 'http://www.ginac.de/'
  md5 '8693b3c9c3467694032ce9c8b3063d4c'

  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
