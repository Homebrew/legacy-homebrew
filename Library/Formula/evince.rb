class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.18/evince-3.18.2.tar.xz"
  sha256 "42ad6c7354d881a9ecab136ea84ff867acb942605bcfac48b6c12e1c2d8ecb17"
  revision 3

  bottle do
    sha256 "1285a7fdb434b1954a82b626af26541e6de62da829701c9c8804f033dc449ed3" => :el_capitan
    sha256 "0d5c8297ab8cf9dac12fd8be506504e5dc7bf7e764faf3285e8a2bd8df474b0f" => :yosemite
    sha256 "276fa2a59c85a06b2ea3e5f0144a6e5a01bb321fe0c1fe8386407c97e9349984" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "poppler"
  depends_on "libxml2" => "with-python"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "gobject-introspection"
  depends_on "shared-mime-info"
  depends_on "djvulibre"
  depends_on :python if MacOS.version <= :snow_leopard

  # adds support for UTF-8 filenames in the DjVu backend
  # submitted upstream as https://bugzilla.gnome.org/show_bug.cgi?id=761161
  patch :DATA

  def install
    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-nautilus",
                          "--disable-schemas-compile",
                          "--enable-introspection",
                          "--enable-djvu",
                          "--disable-browser-plugin"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/evince --version")
  end
end

__END__
diff --git a/backend/djvu/djvu-document.c b/backend/djvu/djvu-document.c
index 06ce813..6711f31 100644
--- a/backend/djvu/djvu-document.c
+++ b/backend/djvu/djvu-document.c
@@ -164,8 +164,12 @@ djvu_document_load (EvDocument  *document,
	filename = g_filename_from_uri (uri, NULL, error);
	if (!filename)
		return FALSE;
-
+
+#ifdef __APPLE__
+	doc = ddjvu_document_create_by_filename_utf8 (djvu_document->d_context, filename, TRUE);
+#else
	doc = ddjvu_document_create_by_filename (djvu_document->d_context, filename, TRUE);
+#endif

	if (!doc) {
		g_free (filename);
