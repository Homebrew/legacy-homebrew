require 'formula'

class Quassel < Formula
  homepage 'http://www.quassel-irc.org/'
  url 'http://www.quassel-irc.org/pub/quassel-0.9.0.tar.bz2'
  sha1 '07f562c692738c09891ebd8bea703f68ba695180'

  head 'git://git.quassel-irc.org/quassel.git'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def patches
    DATA
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

__END__
--- a/src/qtui/chatscene.cpp	2012-03-20 13:39:20.000000000 -0700
+++ b/src/qtui/chatscene.cpp	2012-06-20 10:06:44.000000000 -0700
@@ -33,7 +33,7 @@
 #endif
 
 #ifdef HAVE_WEBKIT
-#  include <QWebView>
+#  include <QtWebKit/QWebView>
 #endif
 
 #include "chatitem.h"
--- a/src/qtui/webpreviewitem.cpp	2012-03-20 13:39:20.000000000 -0700
+++ b/src/qtui/webpreviewitem.cpp	2012-06-20 10:08:51.000000000 -0700
@@ -24,8 +24,8 @@
 
 #include <QGraphicsProxyWidget>
 #include <QPainter>
-#include <QWebView>
-#include <QWebSettings>
+#include <QtWebKit/QWebView>
+#include <QtWebKit/QWebSettings>
 
 WebPreviewItem::WebPreviewItem(const QUrl &url)
   : QGraphicsItem(0), // needs to be a top level item as we otherwise cannot guarantee that it's on top of other chatlines
--- a/src/common/quassel.cpp
+++ b/src/common/quassel.cpp
@@ -495,7 +495,7 @@ void Quassel::loadTranslation(const QLocale &locale)
     quasselTranslator->setObjectName("QuasselTr");
     qApp->installTranslator(quasselTranslator);
 
-#if QT_VERSION >= 0x040800
+#if QT_VERSION >= 0x040800 && !defined Q_OS_MAC
     bool success = qtTranslator->load(locale, QString("qt_"), translationDirPath());
     if (!success)
         qtTranslator->load(locale, QString("qt_"), QLibraryInfo::location(QLibraryInfo::TranslationsPath));

