class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.18/evince-3.18.0.tar.xz"
  sha256 "96e8351f6a6fc5823bb8f51178cde1182bd66481af6fb09bf58a18b673cafa70"

  bottle do
    sha256 "86b45675070710c313c188f51264ccef08b4406b95a645dcee5950355dddbb48" => :el_capitan
    sha256 "9ea9d564853360a231994a54e31192790b1831826afd7caa8e967e169f1fa056" => :yosemite
    sha256 "808dbf3235cf49c23658a7d77375d8962ffc272723a78f04e908a3019292314d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "poppler"
  depends_on "libxml2" => "with-python"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "gobject-introspection"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-nautilus",
                          "--disable-schemas-compile",
                          "--enable-introspection",
                          "--disable-browser-plugin"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/evince --version")
  end
end
