require 'formula'

class Libxspf < Formula
  url 'http://downloads.xiph.org/releases/xspf/libxspf-1.2.0.tar.bz2'
  homepage 'http://libspiff.sourceforge.net/'
  md5 'eceb3bf8fd4af3b09ea06c5c029cd647'

  depends_on 'cpptest'
  depends_on 'uriparser'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
