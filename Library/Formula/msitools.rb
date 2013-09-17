require 'formula'

class Msitools < Formula
  homepage 'https://wiki.gnome.org/msitools'
  url 'http://ftp.gnome.org/pub/GNOME/sources/msitools/0.93/msitools-0.93.tar.xz'
  sha1 'b8dcf394a1aeddd8404ae1702ce42af623f54101'

  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'pkg-config' => :build
  depends_on :automake => :build
  depends_on :autoconf => :build
  depends_on :libtool
  depends_on 'gcab'
  depends_on 'glib'
  depends_on 'vala'
  depends_on 'libgsf'
  depends_on 'ossp-uuid'
  depends_on 'gettext'

  def patches
    # relax uuid version requirement for ossp-uuid version numbers instead
    # of e2fsprogs version numbers
    DATA
  end

  def install
    # osp-uuid doesn't link uuid.pc to the normal pkg-config path
    ENV.append 'PKG_CONFIG_PATH',
    ":#{Formula.factory('ossp-uuid').opt_prefix}/lib/pkgconfig"
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "msiinfo", "--help"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index ea34ade..a298a17 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,7 +23,7 @@ IT_PROG_INTLTOOL([0.35])
 AM_PATH_GLIB_2_0([2.12.0])
 PKG_CHECK_MODULES([GOBJECT], [gobject-2.0 gio-2.0 >= 2.14])
 PKG_CHECK_MODULES([GSF], [libgsf-1])
-PKG_CHECK_MODULES([UUID], [uuid >= 1.41.3])
+PKG_CHECK_MODULES([UUID], [uuid >= 1.4])
 
 LT_INIT([win32-dll disable-fast-install])
 GOBJECT_INTROSPECTION_CHECK([0.9.4])
@@ -36,7 +36,7 @@ AM_CONDITIONAL([VAPI], [test "x$VAPIGEN" != xno])
 
 PKG_CHECK_MODULES([WIXL], [gio-2.0 >= 0.23.0
                            libgcab-1.0 >= 0.1.10
-                           uuid >= 1.41.3
+                           uuid >= 1.4
                            libxml-2.0 >= 2.7])
 
 GETTEXT_PACKAGE=msitools
diff --git a/tools/msibuild.c b/tools/msibuild.c
index 0e96e81..cd8d110 100644
--- a/tools/msibuild.c
+++ b/tools/msibuild.c
@@ -26,7 +26,6 @@
 #include <sys/stat.h>
 #include <libmsi.h>
 #include <limits.h>
-#include <uuid.h>
 
 #include "sqldelim.h"
 
