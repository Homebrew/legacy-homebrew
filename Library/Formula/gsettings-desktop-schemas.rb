require "formula"

class GsettingsDesktopSchemas < Formula
  homepage "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/"
  url "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.12/gsettings-desktop-schemas-3.12.0.tar.xz"
  sha256 "a623888a47999599abca9728156459b93634e93ac7243a86cf1fc8c2d75f478d"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib" => :build # Yep, for glib-mkenums
  depends_on "gobject-introspection" => :build
  depends_on "gettext"
  depends_on "libffi"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--enable-introspection=yes"
    system "make install"
  end

  def post_install
    # manual schema compile step
    system Formula["glib"].opt_bin/"glib-compile-schemas", share/"glib-2.0/schemas"
  end
end
