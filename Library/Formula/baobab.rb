class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.18/baobab-3.18.1.tar.xz"
  sha256 "c2ac90426390e77147446a290c1480c49936c0a224f740b555ddaec2675b44b5"

  bottle do
    sha256 "55ea4703861707e433de02cf3d18420ffa0de197c089a8a28c4ee5c43917eb88" => :el_capitan
    sha256 "99293f3b05027dad41935c43dfc6aeddabe657ecb780f69849bb32c69b570770" => :yosemite
    sha256 "55e3aba6eb76b43203d32abbb7c299513a97a79b820676cdf525f6eb7d736005" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => ["with-python", :build]
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/baobab --version")
  end
end
