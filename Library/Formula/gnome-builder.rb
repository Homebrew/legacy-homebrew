class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.18/gnome-builder-3.18.1.tar.xz"
  sha256 "501c95220dcf8ca44a5748e863492377fe2c3aee78a95973d6819b1836e5407c"

  bottle do
    sha256 "f7d422a29b7c9b98c20bdce9e8a56b14265fad5d9ce174d77c686adb26d752ad" => :el_capitan
    sha256 "294e0df51b9781d53996761965bde4a300485e92af2f39f79965cbee5203f4e5" => :yosemite
    sha256 "0a7a3ea11c1db7a79faeb78240631b0ea55d59cc2b053a4f89e95769d1f1c26c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "libgit2-glib"
  depends_on "gtk+3"
  depends_on "libpeas"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "pcre"
  depends_on "gjs" => :recommended
  depends_on "vala" => :recommended
  depends_on "devhelp" => :recommended
  depends_on "ctags" => :recommended
  depends_on :python3 => :optional
  depends_on "pygobject3" if build.with? "python3"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/gnome-builder", "--version"
  end
end
