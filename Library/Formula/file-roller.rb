class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.16/file-roller-3.16.4.tar.xz"
  sha256 "5455980b2c9c7eb063d2d65560ae7ab2e7f01b208ea3947e151680231c7a4185"

  bottle do
    sha256 "28b7c7a17489bf7bf443d921778c97dca8607be10a48bc17a7515c24109a12d4" => :yosemite
    sha256 "e4d0be17adc6a550d1abbe5c934cd35edbd46624c731c284ee5357145ae5ad33" => :mavericks
    sha256 "717007431c4b510af5dc653b0141f84c6f01e11e4cb16daf370e1d7e44af5c08" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => ["with-python", :build]
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  def install
    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--disable-packagekit",
                          "--enable-magic"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/file-roller", "--version"
  end
end
