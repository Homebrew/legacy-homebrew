require "formula"

class GsettingsDesktopSchemas < Formula
  homepage "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/"
  url "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.12/gsettings-desktop-schemas-3.12.2.tar.xz"
  sha256 "da75021e9c45a60d0a97ea3486f93444275d0ace86dbd1b97e5d09000d8c4ad1"

  bottle do
    sha1 "02af81f7475b27301648a4b20fb4a9e16995bdc4" => :mavericks
    sha1 "89e7f475d70629e957c0a6e1dbceb7a51a5b4efb" => :mountain_lion
    sha1 "f9285f500be14dd9f6624c4a8765e6ffedf615d1" => :lion
  end

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
