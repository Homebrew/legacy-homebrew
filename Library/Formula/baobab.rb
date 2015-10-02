class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/3.18/baobab-3.18.0.tar.xz"
  sha256 "75924c53dd0e94d97c2f0ec30270fa3ffc59adfab7e21aac3ed9c6c088760b5a"

  bottle do
    sha256 "2a7249796e40649b759d2cadc16ecb09aad5c0388398083aeda81ef7471d64a6" => :el_capitan
    sha256 "c4de764dbe7d153c0d57f26ca98485a78106ec36e314f7d6fdc18b394aa4c023" => :yosemite
    sha256 "7da91161bd3a2fbcb7e22a82c5e3b67a36b67838bd75b908a3bff1c9f1e7a987" => :mavericks
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
