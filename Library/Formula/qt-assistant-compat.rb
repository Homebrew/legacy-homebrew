require "formula"

class QtAssistantCompat < Formula
  homepage "http://blog.qt.digia.com/blog/2010/06/22/qt-assistant-compat-version-available-as-extra-source-package/"
  url "ftp://ftp.qt.nokia.com/qt/source/qt-assistant-qassistantclient-library-compat-src-4.6.3.tar.gz"
  sha1 "7a5e5155136c406e5b7eb880eed752f56625d10b"

  depends_on "qt"
  depends_on "pkg-config" => :build
  patch :DATA

  def install
    cd 'lib' do
      inreplace 'lib.pro' do |s|
        s.gsub! '$$[QT_INSTALL_LIBS]', lib
      end
      system "qmake", "lib.pro"
      system "make"
      system "make", "install"
    end
    # Create symbolik link to /usr/local/include
    Pathname.glob("#{lib}/QtAssistant.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <QtAssistant/QAssistantClient>
      int main(void)
      {
        QAssistantClient *assistantClient = new QAssistantClient("", 0);
        delete assistantClient;
        return 0;
      }
    EOS

    (testpath/'test.pro').write <<-EOS.undent
      TEMPLATE = app
      TARGET = test
      DEPENDPATH += .
      INCLUDEPATH += .
      CONFIG += link_pkgconfig
      PKGCONFIG += QtAssistant
      SOURCES += test.cpp
    EOS

    system "qmake", "test.pro"
    system "make"
    system "./test.app/Contents/MacOS/test"
  end
end


__END__
diff -Naur qt-assistant-qassistantclient-library-compat-version-4.6.3.orig/lib/headers/QAssistantClient qt-assistant-qassistantclient-library-compat-version-4.6.3.patch/lib/headers/QAssistantClient
--- qt-assistant-qassistantclient-library-compat-version-4.6.3.orig/lib/headers/QAssistantClient	1970-01-01 01:00:00.000000000 +0100
+++ qt-assistant-qassistantclient-library-compat-version-4.6.3.patch/lib/headers/QAssistantClient	2014-09-14 14:51:12.000000000 +0200
@@ -0,0 +1 @@
+#include "qassistantclient.h"
diff -Naur qt-assistant-qassistantclient-library-compat-version-4.6.3.orig/lib/headers/QtAssistant qt-assistant-qassistantclient-library-compat-version-4.6.3.patch/lib/headers/QtAssistant
--- qt-assistant-qassistantclient-library-compat-version-4.6.3.orig/lib/headers/QtAssistant	1970-01-01 01:00:00.000000000 +0100
+++ qt-assistant-qassistantclient-library-compat-version-4.6.3.patch/lib/headers/QtAssistant	2014-09-14 14:51:29.000000000 +0200
@@ -0,0 +1,5 @@
+#ifndef QT_QTASSISTANT_MODULE_H
+#define QT_QTASSISTANT_MODULE_H
+#include <QtNetwork/QtNetwork>
+#include "qassistantclient.h"
+#endif
diff -Naur qt-assistant-qassistantclient-library-compat-version-4.6.3.orig/lib/lib.pro qt-assistant-qassistantclient-library-compat-version-4.6.3.patch/lib/lib.pro
--- qt-assistant-qassistantclient-library-compat-version-4.6.3.orig/lib/lib.pro	2010-06-18 11:01:10.000000000 +0200
+++ qt-assistant-qassistantclient-library-compat-version-4.6.3.patch/lib/lib.pro	2014-09-14 15:07:42.000000000 +0200
@@ -16,8 +16,8 @@
                   qassistantclient_global.h
 SOURCES         = qassistantclient.cpp
 
-DESTDIR                = ../../../../lib
-DLLDESTDIR             = ../../../../bin
+DESTDIR                = ../lib
+DLLDESTDIR             = ../bin
 
 unix {
         QMAKE_CFLAGS += $$QMAKE_CFLAGS_SHLIB
@@ -45,7 +45,7 @@
       !debug_and_release|build_pass {
 	  CONFIG -= qt_install_headers #no need to install these as well
 	  FRAMEWORK_HEADERS.version = Versions
-	  FRAMEWORK_HEADERS.files = $$SYNCQT.HEADER_FILES $$SYNCQT.HEADER_CLASSES
+	  FRAMEWORK_HEADERS.files = qassistantclient.h qassistantclient_global.h headers/QAssistantClient headers/QtAssistant
       	  FRAMEWORK_HEADERS.path = Headers
       }
       QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS
@@ -67,8 +67,8 @@
     INSTALLS        += assistant_headers
 }
 
-unix {
-   CONFIG     += create_pc
+unix|mac {
+   CONFIG     += create_pc create_prl no_install_prl
    QMAKE_PKGCONFIG_LIBDIR = $$[QT_INSTALL_LIBS]
    QMAKE_PKGCONFIG_INCDIR = $$[QT_INSTALL_HEADERS]/QtAssistant
    QMAKE_PKGCONFIG_CFLAGS = -I$$[QT_INSTALL_HEADERS]
diff -Naur qt-assistant-qassistantclient-library-compat-version-4.6.3.orig/lib/qassistantclient.h qt-assistant-qassistantclient-library-compat-version-4.6.3.patch/lib/qassistantclient.h
--- qt-assistant-qassistantclient-library-compat-version-4.6.3.orig/lib/qassistantclient.h	2010-06-18 11:01:10.000000000 +0200
+++ qt-assistant-qassistantclient-library-compat-version-4.6.3.patch/lib/qassistantclient.h	2014-09-14 16:06:15.000000000 +0200
@@ -46,7 +46,7 @@
 #include <QtCore/QStringList>
 #include <QtCore/QProcess>
 #include <QtCore/qglobal.h>
-#include <QtAssistant/qassistantclient_global.h>
+#include "qassistantclient_global.h"
 
 QT_BEGIN_HEADER
 
