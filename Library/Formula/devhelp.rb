class Devhelp < Formula
  desc "API documentation browser for GTK+ and GNOME"
  homepage "https://wiki.gnome.org/Apps/Devhelp"
  url "https://download.gnome.org/sources/devhelp/3.18/devhelp-3.18.1.tar.xz"
  sha256 "303a162ad294dc6f9984898e501a06dc5d2aa9812b06801c2e39b250d8c51aef"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "webkitgtk"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/devhelp", "--version"
  end
end
