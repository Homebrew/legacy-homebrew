require 'formula'

class Gtksourceview3 < Formula
  homepage 'http://projects.gnome.org/gtksourceview/'
  url 'http://ftp.acc.umu.se/pub/gnome/sources/gtksourceview/3.2/gtksourceview-3.2.3.tar.xz'
  sha1 '22e9e3c38a10e3ffdec7d5e1179571364e4d3653'
  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+3'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
