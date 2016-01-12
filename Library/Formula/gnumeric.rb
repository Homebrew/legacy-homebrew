class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.26.tar.xz"
  sha256 "48250718133e998f7b2e73f71be970542e46c9096afb936dbcb152cf5394ee14"

  bottle do
    sha256 "d820c2088473b1ec888f03e6a74ee970d694ebc75803a377b8abbc60fcce07f7" => :el_capitan
    sha256 "6621a36baebb580b3933b7f3554f0c51929275b1c854e9231bd1cbbcc9bd95d2" => :yosemite
    sha256 "7b9ed75d0b6849251f5b29ff210357a109f3aaacea05d99a1b70d47a6f126286" => :mavericks
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
