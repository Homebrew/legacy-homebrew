require 'formula'

class Quassel < Formula
  head 'git://git.quassel-irc.org/quassel.git'
  homepage 'http://www.quassel-irc.org/'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def patches
    DATA
  end

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end

__END__
--- a/src/qtui/chatscene.cpp	2009-10-04 17:42:09.000000000 -0400
+++ b/src/qtui/chatscene.cpp	2009-10-04 18:09:13.000000000 -0400
@@ -26,7 +26,7 @@
 #include <QPersistentModelIndex>
 
 #ifdef HAVE_WEBKIT
-#  include <QWebView>
+#  include <QtWebkit/QWebView>
 #endif

#include "chatitem.h"

--- a/src/qtui/webpreviewitem.cpp	2009-10-04 17:42:09.000000000 -0400
+++ b/src/qtui/webpreviewitem.cpp	2009-10-04 18:11:19.000000000 -0400
@@ -24,7 +24,7 @@

 #include <QGraphicsProxyWidget>
 #include <QPainter>
-#include <QWebView>
+#include <QtWebKit/QWebView>

 WebPreviewItem::WebPreviewItem(const QString &url)
   : QGraphicsItem(0), // needs to be a top level item as we otherwise cannot guarantee that it's on top of other chatlines
