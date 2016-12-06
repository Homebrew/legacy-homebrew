require 'formula'

class QalculateGtk < Formula
  url 'http://sourceforge.net/projects/qalculate/files/qalculate-gtk/qalculate-gtk-0.9.7/qalculate-gtk-0.9.7.tar.gz'
  depends_on 'cln'
  depends_on 'libqalculate'
  depends_on 'gtk+'
  depends_on 'libglade'
  depends_on 'gdk-pixbuf'
  depends_on 'scrollkeeper'
  depends_on 'gnome-common'
  homepage 'http://qalculate.sourceforge.net'
  md5 '7a7ab4680e285690ca3625992f477f0f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
