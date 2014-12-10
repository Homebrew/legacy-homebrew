require 'formula'

class Gsmartcontrol < Formula
  homepage 'http://gsmartcontrol.sourceforge.net/home/index.php'
  url 'https://downloads.sourceforge.net/project/gsmartcontrol/0.8.7/gsmartcontrol-0.8.7.tar.bz2'
  sha1 '36c255e8f493b003a616cb1eff3a86ccc6b8f80a'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'smartmontools'
  depends_on 'gtkmm'
  depends_on 'pcre'
  depends_on 'libglademm'

  # Fix bad includes with gtkmm-2.24.3
  # Check if this is still needed with new versions of gsmartcontrol and gtkmm
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/gsmartcontrol", "--version"
  end
end

__END__
diff --git a/src/applib/cmdex_sync_gui.cpp b/src/applib/cmdex_sync_gui.cpp
index d253a17..83b2e11 100644
--- a/src/applib/cmdex_sync_gui.cpp
+++ b/src/applib/cmdex_sync_gui.cpp
@@ -9,6 +9,7 @@
 /// \weakgroup applib
 /// @{
 
+#include <glibmm.h>
 #include <gtkmm/main.h>  // Gtk::Main
 
 #include "hz/fs_path.h"
diff --git a/src/gsc_init.cpp b/src/gsc_init.cpp
index 0ded7bc..6fb1bb7 100644
--- a/src/gsc_init.cpp
+++ b/src/gsc_init.cpp
@@ -15,6 +15,7 @@
 #include <cstdio>  // std::printf
 #include <vector>
 #include <sstream>
+#include <glibmm.h>
 #include <gtkmm/main.h>
 #include <gtkmm/messagedialog.h>
 #include <gtk/gtk.h>  // gtk_window_set_default_icon_name, gtk_icon_theme_*
