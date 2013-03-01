require 'formula'

class Libxspf < Formula
  homepage 'http://libspiff.sourceforge.net/'
  url 'http://downloads.xiph.org/releases/xspf/libxspf-1.2.0.tar.bz2'
  sha1 '23bbc0573636928210f42699029941dd06b20a1d'

  depends_on 'cpptest'
  depends_on 'uriparser'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
