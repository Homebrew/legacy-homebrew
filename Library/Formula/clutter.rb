require 'formula'

class Clutter < Formula
  homepage 'http://clutter-project.org/'
  url 'http://source.clutter-project.org/sources/clutter/1.10/clutter-1.10.6.tar.bz2'
  sha256 '791bf752de2636989b82007d9f2a3a83bba56b13c329f40ca67e4d35ed982b31'

  depends_on 'pkg-config' => :build
  depends_on 'atk'
  # Cairo is keg-only and usually only used for Leopard builds.
  # But Clutter requires a newer version of Cairo that what comes with Snow Leopard.
  depends_on 'cairo'
  depends_on 'intltool'
  depends_on 'json-glib'
  depends_on 'pango'
  depends_on 'cogl'
  depends_on 'gdk-pixbuf'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-flavour=osx",
                          "--with-imagebackend=quartz",
                          "--disable-introspection"
    system "make install"
  end
end
