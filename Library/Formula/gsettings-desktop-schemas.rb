require "formula"

class GsettingsDesktopSchemas < Formula
  homepage "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/"
  url "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.14/gsettings-desktop-schemas-3.14.0.tar.xz"
  sha256 "cf3ba58f6257155080b1872b4a6ce4a2424bb7af3f08e607b428cb47b065f2d7"

  bottle do
    revision 1
    sha1 "23d7c8b2d97fc5a9957573c140da28afe8acfacb" => :yosemite
    sha1 "2bcb5e43cdefd81eef7e3bc45b9df4b7d8c2c847" => :mavericks
    sha1 "b812cc34c9f54f053707cd4a5f5995cf903dd278" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib" => :build # for glib-mkenums
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
