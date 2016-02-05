class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/3.18/ghex-3.18.0.tar.xz"
  sha256 "c5b1eb50a8dd1334880b37617871498b778ea137f79bb43894ec68e4f63dc925"

  bottle do
    sha256 "9eb6931e7ac0fb1ea0e5403cc02cd403a19874269b9d23946a2cfb17c3b8c588" => :el_capitan
    sha256 "2bf38162e119817cf5151c7ac1152fcb722fd9305a5555db865e3a83b027ab6b" => :yosemite
    sha256 "d20ac82df9e830d9579a4ad7689a9162744f1373d601f91edd18b80e3d4fe386" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => [:build, "with-python"]
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/ghex", "--help"
  end
end
