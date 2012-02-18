require 'formula'

class Libgnomecanvas < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/libgnomecanvas/2.30/libgnomecanvas-2.30.1.tar.bz2'
  homepage 'http://www.linuxfromscratch.org/blfs/view/cvs/gnome/libgnomecanvas.html'
  md5 '362ab7b81024b3c3b4a712e7df01b169'

  depends_on 'pango'
  depends_on 'cairo'
  depends_on 'gettext'
  depends_on 'atk'
  depends_on 'glib'
  depends_on 'libart'
  depends_on 'intltool'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end