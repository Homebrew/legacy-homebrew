require 'formula'

class Gtksourceview3 < Formula
  homepage 'http://projects.gnome.org/gtksourceview/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.10/gtksourceview-3.10.1.tar.xz'
  sha1 '195da95964eedf16355c97f1ca5ae99c24ca398b'

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
