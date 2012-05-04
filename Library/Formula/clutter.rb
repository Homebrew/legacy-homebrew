require 'formula'

class Clutter < Formula
  homepage 'http://clutter-project.org/'
  url 'http://source.clutter-project.org/sources/clutter/1.10/clutter-1.10.4.tar.xz'
  mirror 'http://ftp.gnome.org/pub/GNOME/sources/clutter/1.10/clutter-1.10.4.tar.xz'
  sha256 '2f2f03c3f385db402898d2607e72d5ad9be2d14402a900c446273e5ae8be250a'

  depends_on 'pkg-config' => :build
  depends_on 'atk'
  # Cairo is keg-only and usually only used for Leopard builds.
  # But Clutter requires a newer version of Cairo that what comes with Snow Leopard.
  depends_on 'cairo'
  depends_on 'intltool'
  depends_on 'json-glib'
  depends_on 'pango'

  def install
    # Cairo is keg-only so pkg-config files are not linked, but are required for build
    cairo = Formula.factory 'cairo'
    ENV.append 'PKG_CONFIG_PATH', "," + cairo.prefix + "/lib/pkgconfig"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-introspection",
                          "--disable-debug"
    system "make install"
  end
end
