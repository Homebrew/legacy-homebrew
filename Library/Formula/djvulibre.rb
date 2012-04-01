require 'formula'

class Djvulibre < Formula
  homepage 'http://djvu.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/djvu/DjVuLibre/3.5.24/djvulibre-3.5.24.tar.gz'
  sha1 '075d1d4a333a2fe74e4c9240d853be016e27e983'

  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-desktopfiles=no",
                          "--with-x=NO",
                          "--with-qt=NO"
    system "make"
    system "make install"
  end
end
