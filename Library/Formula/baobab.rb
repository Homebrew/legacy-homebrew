class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.16/baobab-3.16.1.tar.xz"
  sha256 "1fe40433df3adda0bcc4d0a6edc2bc2501888798d7e8336ad51d443c9a1fcef2"

  bottle do
    sha256 "3c1abb546e17fa589ba508bd1ce8756c26324ab6eca51f6adaa8a660d67bda02" => :yosemite
    sha256 "1584538290dee932fb278d0659c03bfb697dda6cdb262ce47b12191ba93ec5a1" => :mavericks
    sha256 "fad12e594a6f45ac1b082b2ec13d2eedba468721a51028c7ce5a25f0bf4c8b1f" => :mountain_lion
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
