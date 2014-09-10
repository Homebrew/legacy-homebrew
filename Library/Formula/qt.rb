require 'formula'

class Qt < Formula
  homepage 'http://qt-project.org/'
  # Mirror rather than source set as primary because source is very slow.
  url "http://qtmirror.ics.com/pub/qtproject/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"
  mirror "http://download.qt-project.org/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz"
  sha1 "ddf9c20ca8309a116e0466c42984238009525da6"

  head 'git://gitorious.org/qt/qt.git', :branch => '4.8'

  bottle do
    revision 5
    sha1 "34d66e17aaed4d2067297d4a64482d56f2382339" => :mavericks
    sha1 "9ab96caa65e8b707deeb27caaff9ad8b1e906b2c" => :mountain_lion
    sha1 "18b1d1a4aa89f92c4b9a9f202a95cc0896e03a9d" => :lion
  end

  option :universal
  option 'with-qt3support', 'Build with deprecated Qt3Support module support'
  option 'with-docs', 'Build documentation'
  option 'developer', 'Build and link with developer options'

  depends_on "d-bus" => :optional
  depends_on "mysql" => :optional

  patch :DATA if MacOS.version >= :yosemite

  def install
    ENV.universal_binary if build.universal?

    args = ["-prefix", prefix,
            "-system-zlib",
            "-qt-libtiff", "-qt-libpng", "-qt-libjpeg",
            "-confirm-license", "-opensource",
            "-nomake", "demos", "-nomake", "examples",
            "-cocoa", "-fast", "-release"]

    if ENV.compiler == :clang
        args << "-platform"

        if MacOS.version >= :mavericks
          args << "unsupported/macx-clang-libc++"
        else
          args << "unsupported/macx-clang"
        end
    end

    args << "-plugin-sql-mysql" if build.with? 'mysql'

    if build.with? 'd-bus'
      dbus_opt = Formula["d-bus"].opt_prefix
      args << "-I#{dbus_opt}/lib/dbus-1.0/include"
      args << "-I#{dbus_opt}/include/dbus-1.0"
      args << "-L#{dbus_opt}/lib"
      args << "-ldbus-1"
      args << "-dbus-linked"
    end

    if build.with? 'qt3support'
      args << "-qt3support"
    else
      args << "-no-qt3support"
    end

    args << "-nomake" << "docs" if build.without? 'docs'

    if MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86_64'
    end

    if !MacOS.prefer_64_bit? or build.universal?
      args << '-arch' << 'x86'
    end

    args << '-developer-build' if build.include? 'developer'

    system "./configure", *args
    system "make"
    ENV.j1
    system "make install"

    # what are these anyway?
    (bin+'pixeltool.app').rmtree
    (bin+'qhelpconverter.app').rmtree
    # remove porting file for non-humans
    (prefix+'q3porting.xml').unlink if build.without? 'qt3support'

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink Dir["#{lib}/*.framework"]

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    Pathname.glob("#{lib}/*.framework/Headers") do |path|
      include.install_symlink path => path.parent.basename(".framework")
    end

    Pathname.glob("#{bin}/*.app") { |app| mv app, prefix }
  end

  test do
    system "#{bin}/qmake", '-project'
  end

  def caveats; <<-EOS.undent
    We agreed to the Qt opensource license for you.
    If this is unacceptable you should uninstall.
    EOS
  end
end

__END__
diff --git a/src/gui/dialogs/qcolordialog_mac.mm b/src/gui/dialogs/qcolordialog_mac.mm
index f65422f..df53f6f 100644
--- a/src/gui/dialogs/qcolordialog_mac.mm
+++ b/src/gui/dialogs/qcolordialog_mac.mm
@@ -318,7 +318,7 @@ QT_USE_NAMESPACE
         // It's important that the modal event loop is stopped before
         // we accept/reject QColorDialog, since QColorDialog has its
         // own event loop that needs to be stopped last.
-        [NSApp stopModalWithCode:code];
+        [[NSApplication sharedApplication] stopModalWithCode:code];
     } else {
         // Since we are not in a modal event loop, we can safely close
         // down QColorDialog
@@ -350,7 +350,7 @@ QT_USE_NAMESPACE
     while (!modalEnded) {
 #ifndef QT_NO_EXCEPTIONS
         @try {
-            [NSApp runModalForWindow:mColorPanel];
+            [[NSApplication sharedApplication] runModalForWindow:mColorPanel];
             modalEnded = true;
         } @catch (NSException *) {
             // For some reason, NSColorPanel throws an exception when
@@ -358,7 +358,7 @@ QT_USE_NAMESPACE
             // palette (tab three).
         }
 #else
-        [NSApp runModalForWindow:mColorPanel];
+        [[NSApplication sharedApplication] runModalForWindow:mColorPanel];
         modalEnded = true;
 #endif
     }
@@ -469,10 +469,10 @@ void QColorDialogPrivate::mac_nativeDialogModalHelp()
     // Do a queued meta-call to open the native modal dialog so it opens after the new
     // event loop has started to execute (in QDialog::exec). Using a timer rather than
     // a queued meta call is intentional to ensure that the call is only delivered when
-    // [NSApp run] runs (timers are handeled special in cocoa). If NSApp is not
+    // [NSApplication run] runs (timers are handeled special in cocoa). If NSApplication is not
     // running (which is the case if e.g a top-most QEventLoop has been
     // interrupted, and the second-most event loop has not yet been reactivated (regardless
-    // if [NSApp run] is still on the stack)), showing a native modal dialog will fail.
+    // if [NSApplication run] is still on the stack)), showing a native modal dialog will fail.
     if (delegate){
         Q_Q(QColorDialog);
         QTimer::singleShot(1, q, SLOT(_q_macRunNativeAppModalPanel()));
diff --git a/src/gui/dialogs/qfiledialog_mac.mm b/src/gui/dialogs/qfiledialog_mac.mm
index cb9dc77..da15a61 100644
--- a/src/gui/dialogs/qfiledialog_mac.mm
+++ b/src/gui/dialogs/qfiledialog_mac.mm
@@ -229,7 +229,7 @@ QT_USE_NAMESPACE
     if ([mSavePanel respondsToSelector:@selector(close)])
         [mSavePanel close];
     if ([mSavePanel isSheet])
-        [NSApp endSheet: mSavePanel];
+        [[NSApplication sharedApplication] endSheet: mSavePanel];
 }

 - (void)showModelessPanel
@@ -1162,10 +1162,10 @@ void QFileDialogPrivate::mac_nativeDialogModalHelp()
     // Do a queued meta-call to open the native modal dialog so it opens after the new
     // event loop has started to execute (in QDialog::exec). Using a timer rather than
     // a queued meta call is intentional to ensure that the call is only delivered when
-    // [NSApp run] runs (timers are handeled special in cocoa). If NSApp is not
+    // [NSApplication run] runs (timers are handeled special in cocoa). If NSApplication is not
     // running (which is the case if e.g a top-most QEventLoop has been
     // interrupted, and the second-most event loop has not yet been reactivated (regardless
-    // if [NSApp run] is still on the stack)), showing a native modal dialog will fail.
+    // if [NSApplication run] is still on the stack)), showing a native modal dialog will fail.
     if (nativeDialogInUse){
         Q_Q(QFileDialog);
         QTimer::singleShot(1, q, SLOT(_q_macRunNativeAppModalPanel()));
diff --git a/src/gui/dialogs/qfontdialog_mac.mm b/src/gui/dialogs/qfontdialog_mac.mm
index f5484f0..75c37d2 100644
--- a/src/gui/dialogs/qfontdialog_mac.mm
+++ b/src/gui/dialogs/qfontdialog_mac.mm
@@ -230,7 +230,7 @@ static QFont qfontForCocoaFont(NSFont *cocoaFont, const QFont &resolveFont)
     mAppModal = true;
     NSWindow *ourPanel = [mStolenContentView window];
     [ourPanel setReleasedWhenClosed:NO];
-    [NSApp runModalForWindow:ourPanel];
+    [[NSApplication sharedApplication] runModalForWindow:ourPanel];
     QAbstractEventDispatcher::instance()->interrupt();

     if (mReturnCode == NSOKButton)
@@ -256,7 +256,7 @@ static QFont qfontForCocoaFont(NSFont *cocoaFont, const QFont &resolveFont)

     mAppModal = false;
     NSWindow *ourPanel = [mStolenContentView window];
-    [NSApp beginSheet:ourPanel
+    [[NSApplication sharedApplication] beginSheet:ourPanel
         modalForWindow:window
         modalDelegate:0
         didEndSelector:0
@@ -456,7 +456,7 @@ static QFont qfontForCocoaFont(NSFont *cocoaFont, const QFont &resolveFont)

     if (mAppModal) {
         mReturnCode = code;
-        [NSApp stopModalWithCode:code];
+        [[NSApplication sharedApplication] stopModalWithCode:code];
     } else {
         if (code == NSOKButton)
             mPriv->fontDialog()->accept();
@@ -636,10 +636,10 @@ void QFontDialogPrivate::mac_nativeDialogModalHelp()
     // Do a queued meta-call to open the native modal dialog so it opens after the new
     // event loop has started to execute (in QDialog::exec). Using a timer rather than
     // a queued meta call is intentional to ensure that the call is only delivered when
-    // [NSApp run] runs (timers are handeled special in cocoa). If NSApp is not
+    // [NSApplication run] runs (timers are handeled special in cocoa). If NSApplication is not
     // running (which is the case if e.g a top-most QEventLoop has been
     // interrupted, and the second-most event loop has not yet been reactivated (regardless
-    // if [NSApp run] is still on the stack)), showing a native modal dialog will fail.
+    // if [NSApplication run] is still on the stack)), showing a native modal dialog will fail.
     if (nativeDialogInUse) {
         Q_Q(QFontDialog);
         QTimer::singleShot(1, q, SLOT(_q_macRunNativeAppModalPanel()));
diff --git a/src/gui/kernel/qapplication_mac.mm b/src/gui/kernel/qapplication_mac.mm
index 445189d..e4516da 100644
--- a/src/gui/kernel/qapplication_mac.mm
+++ b/src/gui/kernel/qapplication_mac.mm
@@ -468,7 +468,7 @@ void qt_mac_set_app_icon(const QPixmap &pixmap)
         image = static_cast<NSImage *>(qt_mac_create_nsimage(pixmap));
     }

-    [NSApp setApplicationIconImage:image];
+    [[NSApplication sharedApplication] setApplicationIconImage:image];
     [image release];
 #endif
 }
@@ -750,7 +750,7 @@ void qt_event_request_showsheet(QWidget *w)
     Q_ASSERT(qt_mac_is_macsheet(w));
 #ifdef QT_MAC_USE_COCOA
     w->repaint();
-    [NSApp beginSheet:qt_mac_window_for(w) modalForWindow:qt_mac_window_for(w->parentWidget())
+    [[NSApplication sharedApplication] beginSheet:qt_mac_window_for(w) modalForWindow:qt_mac_window_for(w->parentWidget())
         modalDelegate:nil didEndSelector:nil contextInfo:0];
 #else
     qt_mac_event_remove(request_showsheet_pending);
@@ -992,7 +992,7 @@ Q_GUI_EXPORT void qt_mac_set_dock_menu(QMenu *menu)
 {
     qt_mac_dock_menu = menu;
 #ifdef QT_MAC_USE_COCOA
-    [NSApp setDockMenu:menu->macMenu()];
+    [[NSApplication sharedApplication] setDockMenu:menu->macMenu()];
 #else
     SetApplicationDockTileMenu(menu->macMenu());
 #endif
@@ -1011,7 +1011,7 @@ void qt_mac_event_release(QWidget *w)
 #ifndef QT_MAC_USE_COCOA
             SetApplicationDockTileMenu(0);
 #else
-            [NSApp setDockMenu:0];
+            [[NSApplication sharedApplication] setDockMenu:0];
 #endif
         }
     }
@@ -1463,7 +1463,7 @@ QWidget *QApplication::topLevelAt(const QPoint &p)
     NSWindowList(windowCount, windowList.data());
     int firstQtWindowFound = -1;
     for (int i = 0; i < windowCount; ++i) {
-        NSWindow *window = [NSApp windowWithWindowNumber:windowList[i]];
+        NSWindow *window = [[NSApplication sharedApplication] windowWithWindowNumber:windowList[i]];
         if (window) {
             QWidget *candidateWindow = [window QT_MANGLE_NAMESPACE(qt_qwidget)];
             if (candidateWindow && firstQtWindowFound == -1)
@@ -3071,7 +3071,7 @@ bool QApplicationPrivate::canQuit()
 #else
     Q_Q(QApplication);
 #ifdef QT_MAC_USE_COCOA
-    [[NSApp mainMenu] cancelTracking];
+    [[[NSApplication sharedApplication] mainMenu] cancelTracking];
 #else
     HiliteMenu(0);
 #endif
@@ -3146,7 +3146,7 @@ void onApplicationChangedActivation( bool activated )
         }

         if (!app->activeWindow()) {
-            OSWindowRef wp = [NSApp keyWindow];
+            OSWindowRef wp = [[NSApplication sharedApplication] keyWindow];
             if (QWidget *tmp_w = qt_mac_find_window(wp))
                 app->setActiveWindow(tmp_w);
         }
diff --git a/src/gui/kernel/qcocoaapplication_mac.mm b/src/gui/kernel/qcocoaapplication_mac.mm
index 473eec1..6af7b79 100644
--- a/src/gui/kernel/qcocoaapplication_mac.mm
+++ b/src/gui/kernel/qcocoaapplication_mac.mm
@@ -147,7 +147,7 @@ QT_USE_NAMESPACE
     if ([event type] == NSApplicationDefined) {
         switch ([event subtype]) {
             case QtCocoaEventSubTypePostMessage:
-                [NSApp QT_MANGLE_NAMESPACE(qt_sendPostedMessage):event];
+                [[NSApplication sharedApplication] QT_MANGLE_NAMESPACE(qt_sendPostedMessage):event];
                 return true;
             default:
                 break;
@@ -174,7 +174,7 @@ QT_USE_NAMESPACE
     // be called instead of sendEvent if redirection occurs.
     // 'self' will then be an instance of NSApplication
     // (and not QNSApplication)
-    if (![NSApp QT_MANGLE_NAMESPACE(qt_filterEvent):event])
+    if (![[NSApplication sharedApplication] QT_MANGLE_NAMESPACE(qt_filterEvent):event])
         [self QT_MANGLE_NAMESPACE(qt_sendEvent_original):event];
 }

@@ -182,7 +182,7 @@ QT_USE_NAMESPACE
 {
     // This method will be called if
     // no redirection occurs
-    if (![NSApp QT_MANGLE_NAMESPACE(qt_filterEvent):event])
+    if (![[NSApplication sharedApplication] QT_MANGLE_NAMESPACE(qt_filterEvent):event])
         [super sendEvent:event];
 }

@@ -194,7 +194,7 @@ QT_USE_NAMESPACE
     // visible on screen. Note: If Qt is used as a plugin, Qt will not use a
     // native menu bar. Hence, we will also not need to do any redirection etc. as
     // we do with sendEvent.
-    [[NSApp QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)] qtDispatcherToQAction:sender];
+    [[[NSApplication sharedApplication] QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)] qtDispatcherToQAction:sender];
 }

 @end
@@ -203,7 +203,7 @@ QT_BEGIN_NAMESPACE

 void qt_redirectNSApplicationSendEvent()
 {
-    if ([NSApp isMemberOfClass:[QT_MANGLE_NAMESPACE(QNSApplication) class]]) {
+    if ([[NSApplication sharedApplication] isMemberOfClass:[QT_MANGLE_NAMESPACE(QNSApplication) class]]) {
         // No need to change implementation since Qt
         // already controls a subclass of NSApplication
         return;
diff --git a/src/gui/kernel/qcocoaapplicationdelegate_mac.mm b/src/gui/kernel/qcocoaapplicationdelegate_mac.mm
index d45f5f1..cf46a87 100644
--- a/src/gui/kernel/qcocoaapplicationdelegate_mac.mm
+++ b/src/gui/kernel/qcocoaapplicationdelegate_mac.mm
@@ -122,7 +122,7 @@ static void cleanupCocoaApplicationDelegate()
     [dockMenu release];
     [qtMenuLoader release];
     if (reflectionDelegate) {
-        [NSApp setDelegate:reflectionDelegate];
+        [[NSApplication sharedApplication] setDelegate:reflectionDelegate];
         [reflectionDelegate release];
     }
     [super dealloc];
@@ -183,7 +183,7 @@ static void cleanupCocoaApplicationDelegate()
     return [[qtMenuLoader retain] autorelease];
 }

-// This function will only be called when NSApp is actually running. Before
+// This function will only be called when NSApplication is actually running. Before
 // that, the kAEQuitApplication Apple event will be sent to
 // QApplicationPrivate::globalAppleEventProcessor in qapplication_mac.mm
 - (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
@@ -249,7 +249,7 @@ static void cleanupCocoaApplicationDelegate()
         && [reflectionDelegate respondsToSelector:
                             @selector(applicationShouldTerminateAfterLastWindowClosed:)])
         return [reflectionDelegate applicationShouldTerminateAfterLastWindowClosed:sender];
-    return NO; // Someday qApp->quitOnLastWindowClosed(); when QApp and NSApp work closer together.
+    return NO; // Someday qApp->quitOnLastWindowClosed(); when qApp and NSApplication work closer together.
 }


@@ -308,7 +308,7 @@ static void cleanupCocoaApplicationDelegate()
     QDesktopWidgetImplementation::instance()->onResize();
 }

-- (void)setReflectionDelegate:(NSObject <NSApplicationDelegate> *)oldDelegate
+- (void)setReflectionDelegate:(id <NSApplicationDelegate>)oldDelegate
 {
     [oldDelegate retain];
     [reflectionDelegate release];
@@ -355,12 +355,12 @@ static void cleanupCocoaApplicationDelegate()
 {
     Q_UNUSED(event);
     Q_UNUSED(replyEvent);
-    [NSApp terminate:self];
+    [[NSApplication sharedApplication] terminate:self];
 }

 - (void)qtDispatcherToQAction:(id)sender
 {
-    [[NSApp QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)] qtDispatcherToQAction:sender];
+    [[[NSApplication sharedApplication] QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)] qtDispatcherToQAction:sender];
 }

 @end
diff --git a/src/gui/kernel/qcocoaapplicationdelegate_mac_p.h b/src/gui/kernel/qcocoaapplicationdelegate_mac_p.h
index 7ff08d2..5a43d36 100644
--- a/src/gui/kernel/qcocoaapplicationdelegate_mac_p.h
+++ b/src/gui/kernel/qcocoaapplicationdelegate_mac_p.h
@@ -113,7 +113,7 @@ QT_FORWARD_DECLARE_CLASS(QApplicationPrivate);
     QApplicationPrivate *qtPrivate;
     NSMenu *dockMenu;
     QT_MANGLE_NAMESPACE(QCocoaMenuLoader) *qtMenuLoader;
-    NSObject <NSApplicationDelegate> *reflectionDelegate;
+    id <NSApplicationDelegate> reflectionDelegate;
     bool inLaunch;
 }
 + (QT_MANGLE_NAMESPACE(QCocoaApplicationDelegate)*)sharedDelegate;
@@ -122,7 +122,7 @@ QT_FORWARD_DECLARE_CLASS(QApplicationPrivate);
 - (QApplicationPrivate *)qAppPrivate;
 - (void)setMenuLoader:(QT_MANGLE_NAMESPACE(QCocoaMenuLoader)*)menuLoader;
 - (QT_MANGLE_NAMESPACE(QCocoaMenuLoader) *)menuLoader;
-- (void)setReflectionDelegate:(NSObject <NSApplicationDelegate> *)oldDelegate;
+- (void)setReflectionDelegate:(id <NSApplicationDelegate>)oldDelegate;
 - (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent;
 @end
 #endif
diff --git a/src/gui/kernel/qcocoamenuloader_mac.mm b/src/gui/kernel/qcocoamenuloader_mac.mm
index 03fed56..c712950 100644
--- a/src/gui/kernel/qcocoamenuloader_mac.mm
+++ b/src/gui/kernel/qcocoamenuloader_mac.mm
@@ -92,8 +92,8 @@ QT_USE_NAMESPACE
     // 'Quit' item. When changing menu bar (e.g when switching between
     // windows with different menu bars), we never recreate this menu, but
     // instead pull it out the current menu bar and place into the new one:
-    NSMenu *mainMenu = [NSApp mainMenu];
-    if ([NSApp mainMenu] == menu)
+    NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
+    if ([[NSApplication sharedApplication] mainMenu] == menu)
         return; // nothing to do (menu is the current menu bar)!

 #ifndef QT_NAMESPACE
@@ -201,27 +201,27 @@ QT_USE_NAMESPACE

 - (void)terminate:(id)sender
 {
-    [NSApp terminate:sender];
+    [[NSApplication sharedApplication] terminate:sender];
 }

 - (void)orderFrontStandardAboutPanel:(id)sender
 {
-    [NSApp orderFrontStandardAboutPanel:sender];
+    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
 }

 - (void)hideOtherApplications:(id)sender
 {
-    [NSApp hideOtherApplications:sender];
+    [[NSApplication sharedApplication] hideOtherApplications:sender];
 }

 - (void)unhideAllApplications:(id)sender
 {
-    [NSApp unhideAllApplications:sender];
+    [[NSApplication sharedApplication] unhideAllApplications:sender];
 }

 - (void)hide:(id)sender
 {
-    [NSApp hide:sender];
+    [[NSApplication sharedApplication] hide:sender];
 }

 - (void)qtUpdateMenubar
@@ -258,7 +258,7 @@ QT_USE_NAMESPACE

  - (void)orderFrontCharacterPalette:(id)sender
  {
-     [NSApp orderFrontCharacterPalette:sender];
+     [[NSApplication sharedApplication] orderFrontCharacterPalette:sender];
  }

 - (BOOL)validateMenuItem:(NSMenuItem*)menuItem
@@ -266,7 +266,7 @@ QT_USE_NAMESPACE
     if ([menuItem action] == @selector(hide:)
         || [menuItem action] == @selector(hideOtherApplications:)
         || [menuItem action] == @selector(unhideAllApplications:)) {
-        return [NSApp validateMenuItem:menuItem];
+        return [[NSApplication sharedApplication] validateMenuItem:menuItem];
     } else {
         return [menuItem isEnabled];
     }
diff --git a/src/gui/kernel/qcocoasharedwindowmethods_mac_p.h b/src/gui/kernel/qcocoasharedwindowmethods_mac_p.h
index 02cd007..cec899b 100644
--- a/src/gui/kernel/qcocoasharedwindowmethods_mac_p.h
+++ b/src/gui/kernel/qcocoasharedwindowmethods_mac_p.h
@@ -143,7 +143,7 @@ QT_END_NAMESPACE
 {
     // This function is called from the quit item in the menubar when this window
     // is in the first responder chain (see also qtDispatcherToQAction above)
-    [NSApp terminate:sender];
+    [[NSApplication sharedApplication] terminate:sender];
 }

 - (void)setLevel:(NSInteger)windowLevel
@@ -364,7 +364,7 @@ QT_END_NAMESPACE

     if ([sender draggingSource] != nil) {
         // modifier flags might have changed, update it here since we don't send any input events.
-        QApplicationPrivate::modifier_buttons = qt_cocoaModifiers2QtModifiers([[NSApp currentEvent] modifierFlags]);
+        QApplicationPrivate::modifier_buttons = qt_cocoaModifiers2QtModifiers([[[NSApplication sharedApplication] currentEvent] modifierFlags]);
         modifiers = QApplication::keyboardModifiers();
     } else {
         // when the source is from another application the above technique will not work.
@@ -456,7 +456,7 @@ QT_END_NAMESPACE

     // Update modifiers:
     if ([sender draggingSource] != nil) {
-        QApplicationPrivate::modifier_buttons = qt_cocoaModifiers2QtModifiers([[NSApp currentEvent] modifierFlags]);
+        QApplicationPrivate::modifier_buttons = qt_cocoaModifiers2QtModifiers([[[NSApplication sharedApplication] currentEvent] modifierFlags]);
         modifiers = QApplication::keyboardModifiers();
     } else {
         modifiers = qt_cocoaDragOperation2QtModifiers(nsActions);
diff --git a/src/gui/kernel/qeventdispatcher_mac.mm b/src/gui/kernel/qeventdispatcher_mac.mm
index a35fb68..e830eba 100644
--- a/src/gui/kernel/qeventdispatcher_mac.mm
+++ b/src/gui/kernel/qeventdispatcher_mac.mm
@@ -461,7 +461,7 @@ static bool qt_mac_send_event(QEventLoop::ProcessEventsFlags, OSEventRef event,
     if (pt)
         [pt sendEvent:event];
     else
-        [NSApp sendEvent:event];
+        [[NSApplication sharedApplication] sendEvent:event];
     return true;
 #endif
 }
@@ -521,12 +521,12 @@ static inline void qt_mac_waitForMoreEvents()
     // (and free up cpu time) until at least one event occur.
     // This implementation is a bit on the edge, but seems to
     // work fine:
-    NSEvent* event = [NSApp nextEventMatchingMask:NSAnyEventMask
+    NSEvent* event = [[NSApplication sharedApplication] nextEventMatchingMask:NSAnyEventMask
         untilDate:[NSDate distantFuture]
         inMode:NSDefaultRunLoopMode
         dequeue:YES];
     if (event)
-        [NSApp postEvent:event atStart:YES];
+        [[NSApplication sharedApplication] postEvent:event atStart:YES];
 #endif
 }

@@ -537,12 +537,12 @@ static inline void qt_mac_waitForMoreModalSessionEvents()
     // (and free up cpu time) until at least one event occur.
     // This implementation is a bit on the edge, but seems to
     // work fine:
-    NSEvent* event = [NSApp nextEventMatchingMask:NSAnyEventMask
+    NSEvent* event = [[NSApplication sharedApplication] nextEventMatchingMask:NSAnyEventMask
         untilDate:[NSDate distantFuture]
         inMode:NSModalPanelRunLoopMode
         dequeue:YES];
     if (event)
-        [NSApp postEvent:event atStart:YES];
+        [[NSApplication sharedApplication] postEvent:event atStart:YES];
 }
 #endif

@@ -588,23 +588,23 @@ bool QEventDispatcherMac::processEvents(QEventLoop::ProcessEventsFlags flags)
         // done from the application itself. And if processEvents is called
         // manually (rather than from a QEventLoop), we cannot enter a tight
         // loop and block this call, but instead we need to return after one flush.
-        // Finally, if we are to exclude user input events, we cannot call [NSApp run]
+        // Finally, if we are to exclude user input events, we cannot call [NSApplication run]
         // as we then loose control over which events gets dispatched:
-        const bool canExec_3rdParty = d->nsAppRunCalledByQt || ![NSApp isRunning];
+        const bool canExec_3rdParty = d->nsAppRunCalledByQt || ![[NSApplication sharedApplication] isRunning];
         const bool canExec_Qt = !excludeUserEvents &&
                 (flags & QEventLoop::DialogExec || flags & QEventLoop::EventLoopExec) ;

         if (canExec_Qt && canExec_3rdParty) {
             // We can use exec-mode, meaning that we can stay in a tight loop until
             // interrupted. This is mostly an optimization, but it allow us to use
-            // [NSApp run], which is the normal code path for cocoa applications.
+            // [NSApplication run], which is the normal code path for cocoa applications.
             if (NSModalSession session = d->currentModalSession()) {
                 QBoolBlocker execGuard(d->currentExecIsNSAppRun, false);
-                while ([NSApp runModalSession:session] == NSRunContinuesResponse && !d->interrupt)
+                while ([[NSApplication sharedApplication] runModalSession:session] == NSRunContinuesResponse && !d->interrupt)
                     qt_mac_waitForMoreModalSessionEvents();

                 if (!d->interrupt && session == d->currentModalSessionCached) {
-                    // Someone called [NSApp stopModal:] from outside the event
+                    // Someone called [[NSApplication sharedApplication] stopModal:] from outside the event
                     // dispatcher (e.g to stop a native dialog). But that call wrongly stopped
                     // 'session' as well. As a result, we need to restart all internal sessions:
                     d->temporarilyStopAllModalSessions();
@@ -612,7 +612,7 @@ bool QEventDispatcherMac::processEvents(QEventLoop::ProcessEventsFlags flags)
             } else {
                 d->nsAppRunCalledByQt = true;
                 QBoolBlocker execGuard(d->currentExecIsNSAppRun, true);
-                [NSApp run];
+                [[NSApplication sharedApplication] run];
             }
             retVal = true;
         } else {
@@ -626,9 +626,9 @@ bool QEventDispatcherMac::processEvents(QEventLoop::ProcessEventsFlags flags)
                     // to use cocoa's native way of running modal sessions:
                     if (flags & QEventLoop::WaitForMoreEvents)
                         qt_mac_waitForMoreModalSessionEvents();
-                    NSInteger status = [NSApp runModalSession:session];
+                    NSInteger status = [[NSApplication sharedApplication] runModalSession:session];
                     if (status != NSRunContinuesResponse && session == d->currentModalSessionCached) {
-                        // INVARIANT: Someone called [NSApp stopModal:] from outside the event
+                        // INVARIANT: Someone called [NSApplication stopModal:] from outside the event
                         // dispatcher (e.g to stop a native dialog). But that call wrongly stopped
                         // 'session' as well. As a result, we need to restart all internal sessions:
                         d->temporarilyStopAllModalSessions();
@@ -637,8 +637,8 @@ bool QEventDispatcherMac::processEvents(QEventLoop::ProcessEventsFlags flags)
                 } else do {
                     // Dispatch all non-user events (but que non-user events up for later). In
                     // this case, we need more control over which events gets dispatched, and
-                    // cannot use [NSApp runModalSession:session]:
-                    event = [NSApp nextEventMatchingMask:NSAnyEventMask
+                    // cannot use [NSApplication runModalSession:session]:
+                    event = [[NSApplication sharedApplication] nextEventMatchingMask:NSAnyEventMask
                     untilDate:nil
                     inMode:NSModalPanelRunLoopMode
                     dequeue: YES];
@@ -655,7 +655,7 @@ bool QEventDispatcherMac::processEvents(QEventLoop::ProcessEventsFlags flags)
                 } while (!d->interrupt && event != nil);
             } else do {
                 // INVARIANT: No modal window is executing.
-                event = [NSApp nextEventMatchingMask:NSAnyEventMask
+                event = [[NSApplication sharedApplication] nextEventMatchingMask:NSAnyEventMask
                 untilDate:nil
                 inMode:NSDefaultRunLoopMode
                 dequeue: YES];
@@ -798,12 +798,12 @@ void QEventDispatcherMacPrivate::ensureNSAppInitialized()
     // we let Cocoa finish the initialization it seems to need. We'll only
     // apply this trick at most once for any application, and we avoid doing it
     // for the common case where main just starts QApplication::exec.
-    if (nsAppRunCalledByQt || [NSApp isRunning])
+    if (nsAppRunCalledByQt || [[NSApplication sharedApplication] isRunning])
         return;
     nsAppRunCalledByQt = true;
     QBoolBlocker block1(interrupt, true);
     QBoolBlocker block2(currentExecIsNSAppRun, true);
-    [NSApp run];
+    [[NSApplication sharedApplication] run];
 }

 void QEventDispatcherMacPrivate::temporarilyStopAllModalSessions()
@@ -812,8 +812,8 @@ void QEventDispatcherMacPrivate::temporarilyStopAllModalSessions()
     // such, make them pending again. The next call to
     // currentModalSession will recreate them again. The
     // reason to stop all session like this is that otherwise
-    // a call [NSApp stop] would not stop NSApp, but rather
-    // the current modal session. So if we need to stop NSApp
+    // a call [NSApplication stop] would not stop NSApplication, but rather
+    // the current modal session. So if we need to stop NSApplication
     // we need to stop all the modal session first. To avoid changing
     // the stacking order of the windows while doing so, we put
     // up a block that is used in QCocoaWindow and QCocoaPanel:
@@ -821,7 +821,7 @@ void QEventDispatcherMacPrivate::temporarilyStopAllModalSessions()
     for (int i=0; i<stackSize; ++i) {
         QCocoaModalSessionInfo &info = cocoaModalSessionStack[i];
         if (info.session) {
-            [NSApp endModalSession:info.session];
+            [[NSApplication sharedApplication] endModalSession:info.session];
             info.session = 0;
         }
     }
@@ -856,7 +856,7 @@ NSModalSession QEventDispatcherMacPrivate::currentModalSession()
             info.nswindow = window;
             [(NSWindow*) info.nswindow retain];
             int levelBeforeEnterModal = [window level];
-            info.session = [NSApp beginModalSessionForWindow:window];
+            info.session = [[NSApplication sharedApplication] beginModalSessionForWindow:window];
             // Make sure we don't stack the window lower that it was before
             // entering modal, in case it e.g. had the stays-on-top flag set:
             if (levelBeforeEnterModal > [window level])
@@ -926,7 +926,7 @@ void QEventDispatcherMacPrivate::cleanupModalSessions()
         cocoaModalSessionStack.remove(i);
         currentModalSessionCached = 0;
         if (info.session) {
-            [NSApp endModalSession:info.session];
+            [[NSApplication sharedApplication] endModalSession:info.session];
             [(NSWindow *)info.nswindow release];
         }
     }
@@ -1057,7 +1057,7 @@ inline static void processPostedEvents(QEventDispatcherMacPrivate *const d, cons
             // pending cocoa events first).
             if (d->currentModalSessionCached)
                 d->temporarilyStopAllModalSessions();
-            [NSApp stop:NSApp];
+            [[NSApplication sharedApplication] stop:[NSApplication sharedApplication]];
             d->cancelWaitForMoreEvents();
         }
 #endif
@@ -1093,7 +1093,8 @@ void QEventDispatcherMacPrivate::cancelWaitForMoreEvents()
     // In case the event dispatcher is waiting for more
     // events somewhere, we post a dummy event to wake it up:
     QMacCocoaAutoReleasePool pool;
-    [NSApp postEvent:[NSEvent otherEventWithType:NSApplicationDefined location:NSZeroPoint
+    [[NSApplication sharedApplication] postEvent:[NSEvent otherEventWithType:NSApplicationDefined
+        location:NSZeroPoint
         modifierFlags:0 timestamp:0. windowNumber:0 context:0
         subtype:QtCocoaEventSubTypeWakeup data1:0 data2:0] atStart:NO];
 }
@@ -1110,7 +1111,7 @@ void QEventDispatcherMac::interrupt()
 #else
     // We do nothing more here than setting d->interrupt = true, and
     // poke the event loop if it is sleeping. Actually stopping
-    // NSApp, or the current modal session, is done inside the send
+    // NSApplication, or the current modal session, is done inside the send
     // posted events callback. We do this to ensure that all current pending
     // cocoa events gets delivered before we stop. Otherwise, if we now stop
     // the last event loop recursion, cocoa will just drop pending posted
@@ -1165,7 +1166,7 @@ QtMacInterruptDispatcherHelp::QtMacInterruptDispatcherHelp() : cancelled(false)
     // The whole point of this class is that we enable a way to interrupt
     // the event dispatcher when returning back to a lower recursion level
     // than where interruptLater was called. This is needed to detect if
-    // [NSApp run] should still be running at the recursion level it is at.
+    // [NSApplication run] should still be running at the recursion level it is at.
     // Since the interrupt is canceled if processEvents is called before
     // this object gets deleted, we also avoid interrupting unnecessary.
     deleteLater();
diff --git a/src/gui/kernel/qt_cocoa_helpers_mac.mm b/src/gui/kernel/qt_cocoa_helpers_mac.mm
index 747a42a..cb4057c 100644
--- a/src/gui/kernel/qt_cocoa_helpers_mac.mm
+++ b/src/gui/kernel/qt_cocoa_helpers_mac.mm
@@ -1697,7 +1697,7 @@ void qt_cocoaPostMessage(id target, SEL selector, int argCount, id arg1, id arg2
     NSEvent *e = [NSEvent otherEventWithType:NSApplicationDefined
         location:NSZeroPoint modifierFlags:0 timestamp:0 windowNumber:0
         context:nil subtype:QtCocoaEventSubTypePostMessage data1:lower data2:upper];
-    [NSApp postEvent:e atStart:NO];
+    [[NSApplication sharedApplication] postEvent:e atStart:NO];
 }

 void qt_cocoaPostMessageAfterEventLoopExit(id target, SEL selector, int argCount, id arg1, id arg2)
@@ -1727,7 +1727,7 @@ void qt_mac_post_retranslateAppMenu()
 {
 #ifdef QT_MAC_USE_COCOA
     QMacCocoaAutoReleasePool pool;
-    qt_cocoaPostMessage([NSApp QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)], @selector(qtTranslateApplicationMenu));
+    qt_cocoaPostMessage([[NSApplication sharedApplication] QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)], @selector(qtTranslateApplicationMenu));
 #endif
 }

diff --git a/src/gui/kernel/qwidget_mac.mm b/src/gui/kernel/qwidget_mac.mm
index f58a755..7e9ebb9 100644
--- a/src/gui/kernel/qwidget_mac.mm
+++ b/src/gui/kernel/qwidget_mac.mm
@@ -220,7 +220,7 @@ static QSize qt_mac_desktopSize()
 static NSDrawer *qt_mac_drawer_for(const QWidget *widget)
 {
     NSView *widgetView = reinterpret_cast<NSView *>(widget->window()->effectiveWinId());
-    NSArray *windows = [NSApp windows];
+    NSArray *windows = [[NSApplication sharedApplication] windows];
     for (NSWindow *window in windows) {
         NSArray *drawers = [window drawers];
         for (NSDrawer *drawer in drawers) {
@@ -254,7 +254,7 @@ static void qt_mac_destructWindow(OSWindowRef window)
 {
 #ifdef QT_MAC_USE_COCOA
     if ([window isVisible] && [window isSheet]){
-        [NSApp endSheet:window];
+        [[NSApplication sharedApplication] endSheet:window];
         [window orderOut:window];
     }

@@ -2439,7 +2439,7 @@ void QWidgetPrivate::recreateMacWindow()
     }
     if ([oldWindow isVisible]){
         if ([oldWindow isSheet])
-            [NSApp endSheet:oldWindow];
+            [[NSApplication sharedApplication] endSheet:oldWindow];
         [oldWindow orderOut:oldWindow];
         show_sys();
     }
@@ -3554,7 +3554,7 @@ void QWidgetPrivate::show_sys()
     }

 #ifdef QT_MAC_USE_COCOA
-    if ([NSApp isActive] && !qt_button_down && !QWidget::mouseGrabber()){
+    if ([[NSApplication sharedApplication] isActive] && !qt_button_down && !QWidget::mouseGrabber()){
         // Update enter/leave immidiatly, don't wait for a move event. But only
         // if no grab exists (even if the grab points to this widget, it seems, ref X11)
         QPoint qlocal, qglobal;
@@ -3605,7 +3605,7 @@ void QWidgetPrivate::hide_sys()
             else
                 HideSheetWindow(window);
 #else
-            [NSApp endSheet:window];
+            [[NSApplication sharedApplication] endSheet:window];
             [window orderOut:window];
 #endif
         } else if(qt_mac_is_macdrawer(q)) {
@@ -3716,7 +3716,7 @@ void QWidgetPrivate::hide_sys()
     }

 #ifdef QT_MAC_USE_COCOA
-    if ([NSApp isActive] && !qt_button_down && !QWidget::mouseGrabber()){
+    if ([[NSApplication sharedApplication] isActive] && !qt_button_down && !QWidget::mouseGrabber()){
         // Update enter/leave immidiatly, don't wait for a move event. But only
         // if no grab exists (even if the grab points to this widget, it seems, ref X11)
         QPoint qlocal, qglobal;
diff --git a/src/gui/styles/qmacstyle_mac.mm b/src/gui/styles/qmacstyle_mac.mm
index 78d0d19..ff3696c 100644
--- a/src/gui/styles/qmacstyle_mac.mm
+++ b/src/gui/styles/qmacstyle_mac.mm
@@ -780,7 +780,7 @@ static QSize qt_aqua_get_known_size(QStyle::ContentsType ct, const QWidget *widg
             if (!GetThemeMenuBarHeight(&size))
                 ret = QSize(-1, size);
 #else
-            ret = QSize(-1, [[NSApp mainMenu] menuBarHeight]);
+            ret = QSize(-1, [[[NSApplication sharedApplication] mainMenu] menuBarHeight]);
             // In the qt_mac_set_native_menubar(false) case,
             // we come it here with a zero-height main menu,
             // preventing the in-window menu from displaying.
diff --git a/src/gui/util/qsystemtrayicon_mac.mm b/src/gui/util/qsystemtrayicon_mac.mm
index 3d7ca14..07e3ea2 100644
--- a/src/gui/util/qsystemtrayicon_mac.mm
+++ b/src/gui/util/qsystemtrayicon_mac.mm
@@ -536,7 +536,7 @@ private:
 #ifndef QT_MAC_USE_COCOA
                 const short scale = GetMBarHeight();
 #else
-                const short scale = [[NSApp mainMenu] menuBarHeight];
+                const short scale = [[[NSApplication sharedApplication] mainMenu] menuBarHeight];
 #endif
                 NSImage *nsimage = static_cast<NSImage *>(qt_mac_create_nsimage(icon.pixmap(QSize(scale, scale))));
                 [item setImage: nsimage];
diff --git a/src/gui/widgets/qcocoamenu_mac.mm b/src/gui/widgets/qcocoamenu_mac.mm
index c31416a..54bf11c 100644
--- a/src/gui/widgets/qcocoamenu_mac.mm
+++ b/src/gui/widgets/qcocoamenu_mac.mm
@@ -202,7 +202,7 @@ QT_USE_NAMESPACE
      static SEL selForOFCP = NSSelectorFromString(@"orderFrontCharacterPalette:");
      if (index == -1 && selForOFCP == actionSelector) {
          // Check if the 'orderFrontCharacterPalette' SEL exists for QCocoaMenuLoader object
-         QT_MANGLE_NAMESPACE(QCocoaMenuLoader) *loader = [NSApp QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)];
+         QT_MANGLE_NAMESPACE(QCocoaMenuLoader) *loader = [[NSApplication sharedApplication] QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)];
          return [super indexOfItemWithTarget:loader andAction:actionSelector];
      }
      return index;
diff --git a/src/gui/widgets/qmenu_mac.mm b/src/gui/widgets/qmenu_mac.mm
index 12ef70d..669f824 100644
--- a/src/gui/widgets/qmenu_mac.mm
+++ b/src/gui/widgets/qmenu_mac.mm
@@ -179,7 +179,7 @@ static void cancelAllMenuTracking()
 {
 #ifdef QT_MAC_USE_COCOA
     QMacCocoaAutoReleasePool pool;
-    NSMenu *mainMenu = [NSApp mainMenu];
+    NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
     [mainMenu cancelTracking];
     for (NSMenuItem *item in [mainMenu itemArray]) {
         if ([item submenu]) {
@@ -633,7 +633,7 @@ static inline void syncMenuBarItemsVisiblity(const QMenuBarPrivate::QMacMenuBarP

 static inline QT_MANGLE_NAMESPACE(QCocoaMenuLoader) *getMenuLoader()
 {
-    return [NSApp QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)];
+    return [[NSApplication sharedApplication] QT_MANGLE_NAMESPACE(qt_qcocoamenuLoader)];
 }

 static NSMenuItem *createNSMenuItem(const QString &title)
@@ -2033,7 +2033,7 @@ void qt_mac_clear_menubar()
     QT_MANGLE_NAMESPACE(QCocoaMenuLoader) *loader = getMenuLoader();
     NSMenu *menu = [loader menu];
     [loader ensureAppMenuInMenu:menu];
-    [NSApp setMainMenu:menu];
+    [[NSApplication sharedApplication] setMainMenu:menu];
     const bool modal = qt_mac_should_disable_menu(0);
     if (qt_mac_current_menubar.qmenubar || modal != qt_mac_current_menubar.modal)
         qt_mac_set_modal_state(menu, modal);
@@ -2100,7 +2100,7 @@ bool QMenuBarPrivate::macUpdateMenuBarImmediatly()
 #else
             QT_MANGLE_NAMESPACE(QCocoaMenuLoader) *loader = getMenuLoader();
             [loader ensureAppMenuInMenu:menu];
-            [NSApp setMainMenu:menu];
+            [[NSApplication sharedApplication] setMainMenu:menu];
             syncMenuBarItemsVisiblity(mb->d_func()->mac_menubar);

             if (OSMenuRef tmpMerge = QMenuPrivate::mergeMenuHash.value(menu)) {
@@ -2140,7 +2140,7 @@ bool QMenuBarPrivate::macUpdateMenuBarImmediatly()
 #else
                 QT_MANGLE_NAMESPACE(QCocoaMenuLoader) *loader = getMenuLoader();
                 [loader ensureAppMenuInMenu:menu];
-                [NSApp setMainMenu:menu];
+                [[NSApplication sharedApplication] setMainMenu:menu];
                 syncMenuBarItemsVisiblity(qt_mac_current_menubar.qmenubar->d_func()->mac_menubar);
 #endif
                 qt_mac_set_modal_state(menu, modal);
