require 'formula'

class Libgnomecanvas < Formula
  homepage 'http://developer.gnome.org/libgnomecanvas/2.30/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libgnomecanvas/2.30/libgnomecanvas-2.30.3.tar.bz2'
  sha256 '859b78e08489fce4d5c15c676fec1cd79782f115f516e8ad8bed6abcb8dedd40'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'libglade'
  depends_on 'libart'
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--enable-glade"
    system "make install"
  end
end
