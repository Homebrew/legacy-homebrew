require 'formula'

class Quassel < Formula
  homepage 'http://www.quassel-irc.org/'
  url 'http://www.quassel-irc.org/pub/quassel-0.9.1.tar.bz2'
  sha1 '82bc8ad2f5c0d61a8ec616b84df0504589f19371'

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
@@ -34,7 +34,7 @@
 #endif
 
 #ifdef HAVE_WEBKIT
-#  include <QWebView>
+#  include <QtWebKit/QWebView>
 #endif
 
 #include "chatitem.h"
--- a/src/qtui/webpreviewitem.cpp	2012-03-20 13:39:20.000000000 -0700
+++ b/src/qtui/webpreviewitem.cpp	2012-06-20 10:08:51.000000000 -0700
@@ -25,6 +25,6 @@
 #include <QGraphicsProxyWidget>
 #include <QPainter>
-#include <QWebView>
-#include <QWebSettings>
+#include <QtWebKit/QWebView>
+#include <QtWebKit/QWebSettings>
 
 WebPreviewItem::WebPreviewItem(const QUrl &url)
