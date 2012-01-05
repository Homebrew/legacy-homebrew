require 'formula'

class Libgpod < Formula
  url 'http://sourceforge.net/projects/gtkpod/files/libgpod/libgpod-0.8/libgpod-0.8.0.tar.gz'
  homepage 'http://gtkpod.org/wiki/Libgpod'
  md5 '6660f74cc53293dcc847407aa5f672ce'

  depends_on 'gettext'
  depends_on 'libplist'
  depends_on 'sqlite3'
  # glib-2.0 >= 2.8.0
  # gobject-2.0

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
