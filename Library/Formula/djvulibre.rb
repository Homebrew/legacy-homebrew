require 'formula'

# Note that this formula installs neither the DjVu Spotlight importer,
# nor the DjVu QuickLook plugin.

class Djvulibre <Formula
  url 'http://downloads.sourceforge.net/project/djvu/DjVuLibre/3.5.23/djvulibre-3.5.23.tar.gz'
  homepage 'http://djvu.sourceforge.net/'
  sha1 'b19f6b461515a52eb1048aec81e04dfd836d681f'

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
