class Devhelp < Formula
  desc "API documentation browser for GTK+ and GNOME"
  homepage "https://wiki.gnome.org/Apps/Devhelp"
  url "https://download.gnome.org/sources/devhelp/3.18/devhelp-3.18.1.tar.xz"
  sha256 "303a162ad294dc6f9984898e501a06dc5d2aa9812b06801c2e39b250d8c51aef"

  bottle do
    sha256 "0a8fceef8356c847134a86553a469af6c4e48f72b9e8e9b6576e4bcfe80eca79" => :el_capitan
    sha256 "3f052f305449b5f24d004c1b2561b3fa59c2354d2fb2b54ba61189e115fb91b9" => :yosemite
    sha256 "81fd4026bae8091f1d8485b69189de7cb4184e87f4dadff8a779100c4d19534d" => :mavericks
  end

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
