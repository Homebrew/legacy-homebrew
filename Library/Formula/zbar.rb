require 'formula'

class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage 'http://zbar.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2'
  sha1 '273b47c26788faba4325baecc34063e27a012963'
  revision 1

  option 'with-qt', 'Build with Qt4 support'

  depends_on :x11 => :optional
  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'imagemagick'
  depends_on 'ufraw'
  depends_on 'xz'
  depends_on 'freetype'
  depends_on 'libtool' => :run
  depends_on 'qt' => :optional

  # Fix JPEG handling using patch from
  # http://sourceforge.net/p/zbar/discussion/664596/thread/58b8d79b#8f67
  # already applied upstream but not present in the 0.10 release
  #
  # Fix building zbar with Qt4 support enabled if --with-qt is used
  # x11Info() is only available for X11 based systems (like Linux)
  # building with Qt4 support is not enabled by default.
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-python
      --disable-video
      --without-gtk
    ]

    if build.with? 'x11'
      args << '--with-x'
    else
      args << '--without-x'
    end

    if build.with? 'qt'
      args << '--with-qt'
    else
      args << '--without-qt'
    end

    system "./configure", *args
    system "make install"
  end
end

__END__
diff --git a/zbar/jpeg.c b/zbar/jpeg.c
index fb566f4..d1c1fb2 100644
--- a/zbar/jpeg.c
+++ b/zbar/jpeg.c
@@ -79,8 +79,15 @@ int fill_input_buffer (j_decompress_ptr cinfo)
 void skip_input_data (j_decompress_ptr cinfo,
                       long num_bytes)
 {
-    cinfo->src->next_input_byte = NULL;
-    cinfo->src->bytes_in_buffer = 0;
+    if (num_bytes > 0) {
+        if (num_bytes < cinfo->src->bytes_in_buffer) {
+            cinfo->src->next_input_byte += num_bytes;
+            cinfo->src->bytes_in_buffer -= num_bytes;
+        }
+        else {
+            fill_input_buffer(cinfo);
+        }
+    }
 }
 
 void term_source (j_decompress_ptr cinfo)
diff --git a/qt/QZBar.cpp b/qt/QZBar.cpp
index e1001b0..f3b699f 100644
--- a/qt/QZBar.cpp
+++ b/qt/QZBar.cpp
@@ -23,7 +23,9 @@
 
 #include <qevent.h>
 #include <qurl.h>
-#include <qx11info_x11.h>
+#if defined(Q_WS_X11)
+# include <qx11info_x11.h>
+#endif
 #include <zbar/QZBar.h>
 #include "QZBarThread.h"
 
@@ -48,10 +50,12 @@ QZBar::QZBar (QWidget *parent)
     setSizePolicy(sizing);
 
     thread = new QZBarThread;
+#if defined(Q_WS_X11)
     if(testAttribute(Qt::WA_WState_Created)) {
         thread->window.attach(x11Info().display(), winId());
         _attached = 1;
     }
+#endif
     connect(thread, SIGNAL(videoOpened(bool)),
             this, SIGNAL(videoOpened(bool)));
     connect(this, SIGNAL(videoOpened(bool)),
@@ -203,8 +207,10 @@ void QZBar::changeEvent(QEvent *event)
 {
     try {
         QMutexLocker locker(&thread->mutex);
+#if defined(Q_WS_X11)
         if(event->type() == QEvent::ParentChange)
             thread->window.attach(x11Info().display(), winId());
+#endif
     }
     catch(Exception) { /* ignore (FIXME do something w/error) */ }
 }
@@ -215,9 +221,10 @@ void QZBar::attach ()
         return;
 
     try {
+#if defined(Q_WS_X11)
         thread->window.attach(x11Info().display(), winId());
         _attached = 1;
-
+#endif
         _videoEnabled = !_videoDevice.isEmpty();
         if(_videoEnabled)
             thread->pushEvent(new QZBarThread::VideoDeviceEvent(_videoDevice));
