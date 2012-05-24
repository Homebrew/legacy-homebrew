require 'formula'

class Quassel < Formula
  homepage 'http://www.quassel-irc.org/'
  url 'http://www.quassel-irc.org/pub/quassel-0.7.3.tar.bz2'
  md5 'f12b2b09d8ebe533781aa969597d671c'

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
