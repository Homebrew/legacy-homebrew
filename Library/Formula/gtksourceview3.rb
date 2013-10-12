require 'formula'

class Gtksourceview3 < Formula
  homepage 'http://projects.gnome.org/gtksourceview/'
  url 'http://ftp.acc.umu.se/pub/gnome/sources/gtksourceview/3.10/gtksourceview-3.10.0.tar.xz'
  sha1 '96136aa8b0f133e49269d4c71341fceff32898f7'
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
