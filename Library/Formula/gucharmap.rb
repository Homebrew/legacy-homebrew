class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://live.gnome.org/Gucharmap"
  url "https://download.gnome.org/sources/gucharmap/3.18/gucharmap-3.18.0.tar.xz"
  sha256 "121d2652f59a26c9426c96e7c6ca73295c45b675dd4ef0ccdb1b50bc0b4f3830"

  bottle do
    sha256 "6e08b565a355742462cfe5babc444708d1c9f6a42faa07e3179106bb1e966843" => :yosemite
    sha256 "6a6522fbee8e9bc39dee9cb4fb9458022299991670c85a88bfffc2637ad3da50" => :mavericks
    sha256 "14ac6d6474a7d2aef39c7fe23d959b89fc862b77a94ce5b353ac72a94d6b8238" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "gtk+3"

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic",
                          "--disable-schemas-compile",
                          "--enable-introspection=no"
    system "make"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
