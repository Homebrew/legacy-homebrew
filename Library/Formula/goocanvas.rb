require 'formula'

class Goocanvas < Formula
  homepage 'https://live.gnome.org/GooCanvas'
  url 'http://ftp.gnome.org/pub/GNOME/sources/goocanvas/1.0/goocanvas-1.0.0.tar.bz2'
  sha1 'b41d38726fa537258a5f00908eff2d6aad9a5e50'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'cairo'
  depends_on 'glib'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
