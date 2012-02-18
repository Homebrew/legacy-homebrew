require 'formula'

class FramaC < Formula
  url 'http://frama-c.com/download/frama-c-Nitrogen-20111001.tar.gz'
  homepage 'http://frama-c.com/index.html'
  md5 '09bf25ed3d1b54e2d523166aa4499edd'

  depends_on 'cairo'
  depends_on 'glib'
  depends_on 'pango'
  depends_on 'atk'
  depends_on 'libart'
  depends_on 'gtk+'
  depends_on 'libgnomecanvas'
  depends_on 'gtksourceview'
  depends_on 'gdk-pixbuf'
  depends_on 'lablgtk'
  depends_on 'graphviz'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
