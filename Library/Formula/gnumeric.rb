class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.27.tar.xz"
  sha256 "383a5b6eca17f0a5a0b552edcc10320fa719d10c69c7b6fb29d5a11808f1d1c9"

  bottle do
    sha256 "ef111a401feca256bbd20ac542d09024432abf7f5717f55f1251a4de071e3820" => :el_capitan
    sha256 "34217904e0d7133303b927594c962206e7a00837391fc8510b0d48462d65a2a3" => :yosemite
    sha256 "754c6c3eb528a4c6b0b3266c86bc3511139aae3e560da049422b3a888cd5e465" => :mavericks
  end

  option "with-python-scripting", "Enable Python scripting."

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "goffice"
  depends_on "pygobject" if build.include? "python-scripting"
  depends_on "rarian"
  depends_on "gnome-icon-theme"

  deprecated_option "python-scripting" => "with-python-scripting"

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in", "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@", "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gnumeric", "--version"
  end
end
