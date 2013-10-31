require 'formula'

class Phantomjs < Formula
  homepage 'http://www.phantomjs.org/'
  url 'https://phantomjs.googlecode.com/files/phantomjs-1.9.2-source.zip'
  sha1 '08559acdbbe04e963632bc35e94c1a9a082b6da1'

  bottle do
    cellar :any
    revision 1
    sha1 '154fa5b1ea8ce416bfd6957385484450dcea070f' => :mavericks
    sha1 'f90ab68692392269973ba20cd76fda9f9ce22378' => :mountain_lion
    sha1 'a133761fffb7164b97c80f8aee4a419950e2f921' => :lion
  end

  def patches
    DATA
  end

  def install
    inreplace 'src/qt/preconfig.sh', '-arch x86', '-arch x86_64' if MacOS.prefer_64_bit?
    args = ['--confirm', '--qt-config']
    # Fix Clang/LLVM 3DNow! intrinsic failure.
    if MacOS.version >= :lion
      args << '-no-3dnow'
    else
      args << '-no-3dnow -no-ssse3'
    end
    system './build.sh', *args
    bin.install 'bin/phantomjs'
    (share+'phantomjs').install 'examples'
  end
end
__END__
diff --git a/src/qt/src/gui/kernel/qt_cocoa_helpers_mac_p.h b/src/qt/src/gui/kernel/qt_cocoa_helpers_mac_p.h
index c068234..90d2ca0 100644
--- a/src/qt/src/gui/kernel/qt_cocoa_helpers_mac_p.h
+++ b/src/qt/src/gui/kernel/qt_cocoa_helpers_mac_p.h
@@ -110,6 +110,7 @@
 #include "private/qt_mac_p.h"

 struct HIContentBorderMetrics;
+struct TabletProximityRec;

 #ifdef Q_WS_MAC32
 typedef struct _NSPoint NSPoint; // Just redefine here so I don't have to pull in all of Cocoa.
@@ -155,7 +156,6 @@ bool qt_dispatchKeyEvent(void * /*NSEvent * */ keyEvent, QWidget *widgetToGetEve
 void qt_dispatchModifiersChanged(void * /*NSEvent * */flagsChangedEvent, QWidget *widgetToGetEvent);
 bool qt_mac_handleTabletEvent(void * /*QCocoaView * */view, void * /*NSEvent * */event);
 inline QApplication *qAppInstance() { return static_cast<QApplication *>(QCoreApplication::instance()); }
-struct ::TabletProximityRec;
 void qt_dispatchTabletProximityEvent(const ::TabletProximityRec &proxRec);
 Qt::KeyboardModifiers qt_cocoaModifiers2QtModifiers(ulong modifierFlags);
 Qt::KeyboardModifiers qt_cocoaDragOperation2QtModifiers(uint dragOperations);
