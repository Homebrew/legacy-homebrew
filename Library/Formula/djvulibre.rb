require 'formula'

class Djvulibre < Formula
  homepage 'http://djvu.sourceforge.net/'
  url 'http://sourceforge.net/projects/djvu/files/DjVuLibre/3.5.25/djvulibre-3.5.25.3.tar.gz'
  sha1 'ad35056aabb1950f385360ff59520a82a6f779ec'

  depends_on 'jpeg'
  depends_on 'libtiff'

  # Remove this at version >= 3.5.25.4.  This fixes compile errors where
  # INKSCAPE is not found. Reported upstream and fixed in git.
  # https://sourceforge.net/tracker/?func=detail&atid=406583&aid=3534102&group_id=32953
  def patches
    'http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=patch;h=b41a5ac4013ec7dbeeabb88816857581a100ee78'
  end

  def install
    # Several pngs are missing.  Reported upstream and fixed in git head.
    # https://sourceforge.net/tracker/?func=detail&aid=3534280&group_id=32953&atid=406583
    # http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=commit;h=67b4df35e5b7806f9f065253d240ce0529aae52e
    # Remove at version >= 3.5.25.4
    cd 'desktopfiles' do
      curl '-s', '-o', 'prebuilt-hi128-djvu.png', 'http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=blob_plain;f=desktopfiles/prebuilt-hi128-djvu.png;hb=HEAD'
      curl '-s', '-o', 'prebuilt-hi16-djvu.png', 'http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=blob_plain;f=desktopfiles/prebuilt-hi16-djvu.png;hb=HEAD'
      curl '-s', '-o', 'prebuilt-hi20-djvu.png', 'http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=blob_plain;f=desktopfiles/prebuilt-hi20-djvu.png;hb=HEAD'
      curl '-s', '-o', 'prebuilt-hi24-djvu.png', 'http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=blob_plain;f=desktopfiles/prebuilt-hi24-djvu.png;hb=HEAD'
      curl '-s', '-o', 'prebuilt-hi256-djvu.png', 'http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=blob_plain;f=desktopfiles/prebuilt-hi256-djvu.png;hb=HEAD'
      curl '-s', '-o', 'prebuilt-hi72-djvu.png', 'http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=blob_plain;f=desktopfiles/prebuilt-hi72-djvu.png;hb=HEAD'
      curl '-s', '-o', 'prebuilt-hi96-djvu.png', 'http://djvu.git.sourceforge.net/git/gitweb.cgi?p=djvu/djvulibre.git;a=blob_plain;f=desktopfiles/prebuilt-hi96-djvu.png;hb=HEAD'
    end

    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system './configure', "--prefix=#{prefix}", '--disable-desktopfiles'
    system "make"
    system "make install"
  end
end
