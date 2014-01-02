require 'formula'

class Djvulibre < Formula
  homepage 'http://djvu.sourceforge.net/'
  url 'http://ftp.de.debian.org/debian/pool/main/d/djvulibre/djvulibre_3.5.25.4.orig.tar.gz'
  sha1 'c7044201703f30df0f1732c54c6544467412811d'

  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make install"
  end
end
