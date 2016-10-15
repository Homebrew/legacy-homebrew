require "formula"

class Tamuanova < Formula
  homepage "http://www.stat.tamu.edu/~aredd/tamuanova/"
  url "http://ftp.debian.org/debian/pool/main/t/tamuanova/tamuanova_0.2.orig.tar.gz"
  sha1 "8c7ffae14ebe92f27d20ff1f0e325875fa6ced53"

  depends_on "qt"
  depends_on "gsl"

  patch :DATA

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end

__END__
diff -Naur tamu_anova-0.2.orig/tamuanova.pro tamu_anova-0.2.patch/tamuanova.pro
--- tamu_anova-0.2.orig/tamuanova.pro	1970-01-01 01:00:00.000000000 +0100
+++ tamu_anova-0.2.patch/tamuanova.pro	2014-09-11 15:20:56.000000000 +0200
@@ -0,0 +1,34 @@
+isEmpty(PREFIX) {
+  PREFIX = /usr/local
+}
+
+TARGET       = tamuanova
+VERSION      = 0.2.1
+TEMPLATE     = lib
+CONFIG      += warn_on release
+QT          -= gui core
+LIBS        -= -lQtGui -lQtCore
+LIBS        += -lgsl
+
+MOC_DIR      = ./tmp
+OBJECTS_DIR  = ./tmp
+ 
+DEPENDPATH += .
+INCLUDEPATH += .
+
+# Input
+HEADERS += tamu_anova.h
+SOURCES += anova_1.c anova_2.c
+
+target.path = $$PREFIX/lib
+header_files.files = $$HEADERS
+header_files.path = $$PREFIX/include/
+
+INSTALLS += target
+INSTALLS += header_files
+
+CONFIG     += create_pc create_prl no_install_prl
+QMAKE_PKGCONFIG_LIBDIR = $$PREFIX/lib/
+QMAKE_PKGCONFIG_INCDIR = $$PREFIX/include/
+QMAKE_PKGCONFIG_CFLAGS = -I$$PREFIX/include/
+QMAKE_PKGCONFIG_DESTDIR = pkgconfig
