require 'formula'

# Note that this formula installs neither the DjVu Spotlight importer,
# nor the DjVu QuickLook plugin.

class Djvulibre < Formula
  url 'http://downloads.sourceforge.net/project/djvu/DjVuLibre/3.5.24/djvulibre-3.5.24.tar.gz'
  homepage 'http://djvu.sourceforge.net/'
  sha1 '075d1d4a333a2fe74e4c9240d853be016e27e983'

  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    # Don't build X11 GUI apps.
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-desktopfiles=no",
                          "--with-x=NO",
                          "--with-qt=NO"
    system "make"
    system "make install"
  end
end
