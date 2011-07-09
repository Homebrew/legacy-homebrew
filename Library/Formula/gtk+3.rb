require 'formula'

class Gtkx3 < Formula
  homepage 'http://www.gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.1/gtk+-3.1.6.tar.bz2'
  sha256 '9a6837bc00a9f78bffb69b0ce28cfcca8812c04fa061927a7ecb0cb877c5aa0b'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'cairo'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-glibtest"
    system "make install"
  end

  def test
    system "gtk-demo"
  end
end
