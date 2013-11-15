require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'http://downloads.sourceforge.net/project/dar/dar/2.4.11/dar-2.4.11.tar.gz'
  sha1 '02c6257dca054fecbee1e7bcd91ce525f986a67d'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-build-html"
    system "make install"
  end
end
