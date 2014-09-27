require "formula"

class GsettingsDesktopSchemas < Formula
  homepage "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/"
  url "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.14/gsettings-desktop-schemas-3.14.0.tar.xz"
  sha256 "cf3ba58f6257155080b1872b4a6ce4a2424bb7af3f08e607b428cb47b065f2d7"

  bottle do
    sha1 "534f1701a99817b10713dce36014eb4b48e77888" => :mavericks
    sha1 "2c13acc850fe91b08e400efa50091992cca5cf89" => :mountain_lion
    sha1 "3622f61020b21764167881396a164159c1e1b42d" => :lion
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
