class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/3.18/ghex-3.18.0.tar.xz"
  sha256 "c5b1eb50a8dd1334880b37617871498b778ea137f79bb43894ec68e4f63dc925"

  bottle do
    sha256 "e52e0de4433e01d625f49a5bb871b132b395fb57b8dfbcddaf01e97adc9f08e6" => :yosemite
    sha256 "1a85bc508918b1fe7ed481082bc1c0b7f952ecfbd7a514ec9e9ac52f95cc8daa" => :mavericks
    sha256 "7b0c21b630bc1e020362b42e5d2a52d0c04a764c52b03a041a434b4f719a09e7" => :mountain_lion
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
