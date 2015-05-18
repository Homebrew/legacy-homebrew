class GtkEngines < Formula
  desc "Themes for GTK+"
  homepage "https://git.gnome.org/browse/gtk-engines/"
  url "https://download.gnome.org/sources/gtk-engines/2.20/gtk-engines-2.20.2.tar.bz2"
  sha256 "15b680abca6c773ecb85253521fa100dd3b8549befeecc7595b10209d62d66b5"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "cairo"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["GTK2_RC_FILES"] = "#{share}/themes/Clearlooks/gtk-2.0/gtkrc"
    ENV["GTK_PATH"] = "#{HOMEBREW_PREFIX}/lib/gtk-2.0"
    system "#{HOMEBREW_PREFIX}/bin/gtk-demo"
  end

  def caveats; <<-EOS.undent
    You will need to set:
      GTK_PATH=#{HOMEBREW_PREFIX}/lib/gtk-2.0
    as by default GTK looks for modules in Cellar.
    EOS
  end
end
