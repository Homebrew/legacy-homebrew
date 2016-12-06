require 'formula'

class GtkDoc < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtk-doc/1.17/gtk-doc-1.17.tar.gz'
  homepage 'http://www.gtk.org/gtk-doc/'
  md5 'ad3229f89a96d895148808aceb3caa6e'

  depends_on 'docbook'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
