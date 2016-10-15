class GtkMacIntegration < Formula
  homepage "https://wiki.gnome.org/Projects/GTK%2B/OSX"
  url "http://ftp.gnome.org/pub/gnome/sources/gtk-mac-integration/2.0/gtk-mac-integration-2.0.7.tar.xz"
  sha256 "e6de70da740b452f18c113a7ebb6772936a0fb9873137514090849820e296eb7"

  depends_on "pkg-config" => :build
  depends_on "cairo" => "without-x11"
  depends_on "pango" => "without-x11"
  depends_on "gtk+" => "without-x11"
  depends_on "pygtk" => :optional

  head do
    url "git://git.gnome.org/gtk-mac-integration"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  stable do
    # HEAD has fixes for the autotools input files so that the configure script
    # can find the location of PyGObject's datadir. This patch updates the
    # 2.0.7 source distrubution's configure script and Makefile.in files to the
    # same effect. This patch will be obsolete for 2.0.8 and later.
    patch :DATA
  end

  def install
    if build.head?
      ENV["LIBTOOL"] = "glibtool"
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "NOCONFIGURE=1", "./autogen.sh"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gtk=gtk+-2.0"
    system "make", "install"
  end
end

__END__
diff -u gtk-mac-integration-2.0.7/Makefile.in gtk-mac-integration/Makefile.in
--- gtk-mac-integration-2.0.7/Makefile.in	2014-12-28 01:50:34.000000000 +0100
+++ gtk-mac-integration/Makefile.in	2014-12-28 13:42:16.000000000 +0100
@@ -292,6 +289,7 @@
 PYGOBJECT_3_LIBS = @PYGOBJECT_3_LIBS@
 PYGOBJECT_CFLAGS = @PYGOBJECT_CFLAGS@
 PYGOBJECT_CODEGEN = @PYGOBJECT_CODEGEN@
+PYGOBJECT_DATADIR = @PYGOBJECT_DATADIR@
 PYGOBJECT_LIBS = @PYGOBJECT_LIBS@
 PYGTK_CFLAGS = @PYGTK_CFLAGS@
 PYGTK_DEFSDIR = @PYGTK_DEFSDIR@
diff -u gtk-mac-integration-2.0.7/configure gtk-mac-integration/configure
--- gtk-mac-integration-2.0.7/configure	2014-12-28 01:50:34.000000000 +0100
+++ gtk-mac-integration/configure	2014-12-28 13:42:17.000000000 +0100
@@ -652,6 +652,7 @@
 PYGOBJECT_3_CFLAGS
 PYGOBJECT_2_LIBS
 PYGOBJECT_2_CFLAGS
+PYGOBJECT_DATADIR
 PYGTK_DEFSDIR
 PYGOBJECT_CODEGEN
 PYGTK_LIBS
@@ -14680,6 +14932,13 @@
     	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $PYGTK_DEFSDIR" >&5
 $as_echo "$PYGTK_DEFSDIR" >&6; }
 
+    	{ $as_echo "$as_me:${as_lineno-$LINENO}: checking PyGObject DataDir" >&5
+$as_echo_n "checking PyGObject DataDir... " >&6; }
+    	PYGOBJECT_DATADIR=`$PKG_CONFIG --variable=datadir pygobject-2.0`
+
+    	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $PYGOBJECT_DATADIR" >&5
+$as_echo "$PYGOBJECT_DATADIR" >&6; }
+
 elif  test x$GTK_MAJOR = "xgtk+-3.0" -o x$enable_python = "xall"; then :
 
 pkg_failed=no
diff -ru gtk-mac-integration-2.0.7/bindings/Makefile.in gtk-mac-integration/bindings/Makefile.in
--- gtk-mac-integration-2.0.7/bindings/Makefile.in	2014-12-28 01:50:34.000000000 +0100
+++ gtk-mac-integration/bindings/Makefile.in	2014-12-28 13:42:17.000000000 +0100
@@ -269,6 +266,7 @@
 PYGOBJECT_3_LIBS = @PYGOBJECT_3_LIBS@
 PYGOBJECT_CFLAGS = @PYGOBJECT_CFLAGS@
 PYGOBJECT_CODEGEN = @PYGOBJECT_CODEGEN@
+PYGOBJECT_DATADIR = @PYGOBJECT_DATADIR@
 PYGOBJECT_LIBS = @PYGOBJECT_LIBS@
 PYGTK_CFLAGS = @PYGTK_CFLAGS@
 PYGTK_DEFSDIR = @PYGTK_DEFSDIR@
diff -ru gtk-mac-integration-2.0.7/bindings/python/Makefile.in gtk-mac-integration/bindings/python/Makefile.in
--- gtk-mac-integration-2.0.7/bindings/python/Makefile.in	2014-12-28 01:50:34.000000000 +0100
+++ gtk-mac-integration/bindings/python/Makefile.in	2014-12-28 13:42:17.000000000 +0100
@@ -268,6 +265,7 @@
 PYGOBJECT_3_LIBS = @PYGOBJECT_3_LIBS@
 PYGOBJECT_CFLAGS = @PYGOBJECT_CFLAGS@
 PYGOBJECT_CODEGEN = @PYGOBJECT_CODEGEN@
+PYGOBJECT_DATADIR = @PYGOBJECT_DATADIR@
 PYGOBJECT_LIBS = @PYGOBJECT_LIBS@
 PYGTK_CFLAGS = @PYGTK_CFLAGS@
 PYGTK_DEFSDIR = @PYGTK_DEFSDIR@
diff -ru gtk-mac-integration-2.0.7/bindings/python/gtkmacintegration/Makefile.in gtk-mac-integration/bindings/python/gtkmacintegration/Makefile.in
--- gtk-mac-integration-2.0.7/bindings/python/gtkmacintegration/Makefile.in	2014-12-28 01:50:34.000000000 +0100
+++ gtk-mac-integration/bindings/python/gtkmacintegration/Makefile.in	2014-12-28 13:42:17.000000000 +0100
@@ -301,6 +298,7 @@
 PYGOBJECT_3_LIBS = @PYGOBJECT_3_LIBS@
 PYGOBJECT_CFLAGS = @PYGOBJECT_CFLAGS@
 PYGOBJECT_CODEGEN = @PYGOBJECT_CODEGEN@
+PYGOBJECT_DATADIR = @PYGOBJECT_DATADIR@
 PYGOBJECT_LIBS = @PYGOBJECT_LIBS@
 PYGTK_CFLAGS = @PYGTK_CFLAGS@
 PYGTK_DEFSDIR = @PYGTK_DEFSDIR@
diff -ru gtk-mac-integration-2.0.7/bindings/python/gtkosx_application/Makefile.in gtk-mac-integration/bindings/python/gtkosx_application/Makefile.in
--- gtk-mac-integration-2.0.7/bindings/python/gtkosx_application/Makefile.in	2014-12-28 01:50:34.000000000 +0100
+++ gtk-mac-integration/bindings/python/gtkosx_application/Makefile.in	2014-12-28 13:42:17.000000000 +0100
@@ -301,6 +298,7 @@
 PYGOBJECT_3_LIBS = @PYGOBJECT_3_LIBS@
 PYGOBJECT_CFLAGS = @PYGOBJECT_CFLAGS@
 PYGOBJECT_CODEGEN = @PYGOBJECT_CODEGEN@
+PYGOBJECT_DATADIR = @PYGOBJECT_DATADIR@
 PYGOBJECT_LIBS = @PYGOBJECT_LIBS@
 PYGTK_CFLAGS = @PYGTK_CFLAGS@
 PYGTK_DEFSDIR = @PYGTK_DEFSDIR@
@@ -786,7 +784,7 @@
 
 
 gtkosx_application.defs: $(headers)
-	$(PYTHON) $(datadir)/pygobject/2.0/codegen/h2def.py $(headers) > $@
+	$(PYTHON) $(PYGOBJECT_DATADIR)/pygobject/2.0/codegen/h2def.py $(headers) > $@
 
 gtkosx_application.c: gtkosx_application.defs
 
