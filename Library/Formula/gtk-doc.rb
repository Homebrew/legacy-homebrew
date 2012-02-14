require 'formula'

class GtkDoc < Formula
  homepage 'http://www.gtk.org/gtk-doc/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtk-doc/1.18/gtk-doc-1.18.tar.xz'
  md5 '3927bed60fdd0fc9093a1d00018e746a'

  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    
    system "make install"
  end

end
