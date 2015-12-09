class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.18/anjuta-3.18.2.tar.xz"
  sha256 "be864f2f1807e1b870697f646294e997d221d5984a135245543b719e501cef8e"

  bottle do
    revision 1
    sha256 "a86acb12825402db12cf881bb80600a4b04792251202f431806203909ed25eea" => :el_capitan
    sha256 "d886002dcfa6fef994dcebc2e6552b70be5bc0ec346ef3f39525ee40814d5618" => :yosemite
    sha256 "d8d56bd52d1f3eeec0ea3adb7a01c3e6b641236f1a283d408b73d105607417a2" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gtksourceview3"
  depends_on "libxml2" => "with-python"
  depends_on "libgda"
  depends_on "gdl"
  depends_on "vte3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "gnome-themes-standard" => :optional
  depends_on "devhelp" => :optional
  depends_on "shared-mime-info"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "vala" => :recommended
  depends_on "autogen" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    # HighContrast is provided by gnome-themes-standard
    if File.file?("#{HOMEBREW_PREFIX}/share/icons/HighContrast/.icon-theme.cache")
      system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
    end
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    system "#{bin}/anjuta", "--version"
  end
end
