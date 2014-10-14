require 'formula'

class Gpsim < Formula
  homepage 'http://gpsim.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/gpsim/gpsim/0.26.0/gpsim-0.26.1.tar.gz'
  sha1 '7e1c3cc5a821b3458717a94a09bc484bf6937b25'

  head 'svn://svn.code.sf.net/p/gpsim/code/trunk'

  depends_on 'pkg-config' => :build
  depends_on 'popt'
  depends_on 'glib'

  # Patch is upstream; test if it is needed in next release
  patch :DATA

  def install
    system "./configure", "--disable-gui",
                          "--disable-shared",
                          "--prefix=#{prefix}"
    system "make all"
    system "make install"
  end
end


__END__
diff -Naur gpsim-0.26.1/configure.ac gpsim-0.26.1-patch/configure.ac
--- gpsim-0.26.1/configure.ac	2011-04-26 07:13:37.000000000 -0300
+++ gpsim-0.26.1-patch/configure.ac	2013-04-23 10:42:52.000000000 -0300
@@ -79,15 +79,20 @@
 else
   dnl gtk2 checks

-  $PKGCONFIG --exists gtkextra-2.0
+  GTKEXTRAMOD="gtkextra-2.0"
+  $PKGCONFIG --exists $GTKEXTRAMOD
   if test $? != 0; then
-    AC_MSG_ERROR(Cannot find gtkextra-2.0 package)
+    GTKEXTRAMOD="gtkextra-3.0"
+    $PKGCONFIG --exists $GTKEXTRAMOD
+    if test $? != 0; then
+      AC_MSG_ERROR(Cannot find gtkextra-2.0 or gtkextra-3.0 package)
+    fi
   fi

   X_LDFLAGS=`$PKGCONFIG --libs gtk+-2.0 gthread-2.0`
   X_CFLAGS=`$PKGCONFIG --cflags gtk+-2.0`
-  Y_LDFLAGS=`$PKGCONFIG --libs gtkextra-2.0`
-  Y_CFLAGS=`$PKGCONFIG --cflags gtkextra-2.0`
+  Y_LDFLAGS=`$PKGCONFIG --libs $GTKEXTRAMOD`
+  Y_CFLAGS=`$PKGCONFIG --cflags $GTKEXTRAMOD`
   GTK_VERSION_T=`$PKGCONFIG --modversion gtk+-2.0`
   echo linking with gtk-$GTK_VERSION_T
   AC_DEFINE_UNQUOTED([GTK_VERSION],"$GTK_VERSION_T",[gtk version])
diff -Naur gpsim-0.26.1/src/bitlog.h gpsim-0.26.1-patch/src/bitlog.h
--- gpsim-0.26.1/src/bitlog.h	2010-06-05 03:46:30.000000000 -0300
+++ gpsim-0.26.1-patch/src/bitlog.h	2013-04-23 10:37:09.000000000 -0300
@@ -25,7 +25,7 @@

 // include the absolute minimum portion of GLIB to get the definitions
 // for guint64, etc.
-#include <glibconfig.h>
+#include <glib.h>

 /**********************************************************************
  * boolean event logging
