require 'formula'

class Gtksourceview3 < Formula
  homepage 'http://projects.gnome.org/gtksourceview/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.12/gtksourceview-3.12.2.tar.xz'
  sha1 '157ee7291988f89eebdbf6c4bb05e9901572f1ad'

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
