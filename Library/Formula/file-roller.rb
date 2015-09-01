class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.16/file-roller-3.16.3.tar.xz"
  sha256 "2b3a1111caba26e67b96559a3118a700dbfb6a4c6ad7ebd3e509df227995411c"

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

  # patch submitted upstream as https://bugzilla.gnome.org/show_bug.cgi?id=754362
  # has been accepted for 3.16.4
  patch :DATA

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

__END__
diff --git a/src/dlg-package-installer.c b/src/dlg-package-installer.c
index 1b9d8c7..61f0dbf 100644
--- a/src/dlg-package-installer.c
+++ b/src/dlg-package-installer.c
@@ -22,7 +22,6 @@
 #include <config.h>
 #include <string.h>
 #include <glib/gi18n.h>
-#include <gdk/gdkx.h>
 #include <gtk/gtk.h>
 #include "dlg-package-installer.h"
 #include "gio-utils.h"
diff --git a/src/fr-command-lrzip.c b/src/fr-command-lrzip.c
index ad53a13..4fd2927 100644
--- a/src/fr-command-lrzip.c
+++ b/src/fr-command-lrzip.c
@@ -45,7 +45,11 @@ list__process_line (char     *line,

	struct stat st;
	if (stat (comm->filename, &st) == 0)
+#ifdef __APPLE__
+		fdata->modified = st.st_mtime;
+#else
		fdata->modified = st.st_mtim.tv_sec;
+#endif
	else
		time(&(fdata->modified));
