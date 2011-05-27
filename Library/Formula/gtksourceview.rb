require 'formula'

class Gtksourceview < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtksourceview/2.11/gtksourceview-2.11.2.tar.gz'
  homepage 'http://projects.gnome.org/gtksourceview/'
  md5 '7c4bbdc1d1628932362b4f222e80afd4'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
