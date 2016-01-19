class Qxt < Formula
  desc "LibQxt is an extension library for Qt"
  homepage "https://bitbucket.org/libqxt/libqxt/wiki/Home"

  stable do
    url "https://bitbucket.org/libqxt/libqxt/get/v0.6.2.tar.gz"
    sha256 "582426d6c81958dd1ac5ca4a9d49807e0a2204b7343e7d49c6613bcb148b5cb8"
    patch :DATA
  end

  head do
    url "https://bitbucket.org/libqxt/libqxt.git"

    patch :p1, <<EOS
--- a/src/widgets/mac/qxtwindowsystem_mac.cpp
+++ b/src/widgets/mac/qxtwindowsystem_mac.cpp
@@ -89,11 +89,7 @@ QString QxtWindowSystem::windowTitle(WId window)
     // most of CoreGraphics private definitions ask for CGSValue as key but since
     // converting strings to/from CGSValue was dropped in 10.5, I use CFString, which
     // apparently also works.
-    err = CGSGetWindowProperty(connection, window, (CGSValue)CFSTR("kCGSWindowTitle"), &windowTitle);
-    if (err != noErr) return QString();
-
-    // this is UTF8 encoded
-    return QCFString::toQString((CFStringRef)windowTitle);
+    return QString();
 }
EOS
  end

  depends_on "qt"
  depends_on "berkeley-db" => :recommended

  def install
    args = ["-prefix", prefix,
            "-libdir", lib,
            "-release"]

    if build.without? "berkeley-db"
      args << "-no-db"
    end

    system "./configure", *args
    system "make", "install"

    if build.head?
      opoo "Note: QxtWindowSystem::windowTitle is currently unsupported and will return QString()"
    end
  end

  test do
    true
  end
end

__END__
diff --git a/src/gui/qxtglobalshortcut_mac.cpp b/src/gui/qxtglobalshortcut_mac.cpp
index 317e3aa..d0da34a 100644
--- a/src/gui/qxtglobalshortcut_mac.cpp
+++ b/src/gui/qxtglobalshortcut_mac.cpp
@@ -69,63 +69,118 @@ quint32 QxtGlobalShortcutPrivate::nativeKeycode(Qt::Key key)
 {
     UTF16Char ch;
     // Constants found in NSEvent.h from AppKit.framework
-    if (key == Qt::Key_Up)				ch = 0xF700;
-    else if (key == Qt::Key_Down)		ch = 0xF701;
-    else if (key == Qt::Key_Left)		ch = 0xF702;
-    else if (key == Qt::Key_Right)		ch = 0xF703;
-    else if (key >= Qt::Key_F1 && key <= Qt::Key_F35)
-        ch = key - Qt::Key_F1 + 0xF704;
-    else if (key == Qt::Key_Insert)		ch = 0xF727;
-    else if (key == Qt::Key_Delete)		ch = 0xF728;
-    else if (key == Qt::Key_Home)		ch = 0xF729;
-    else if (key == Qt::Key_End)			ch = 0xF72B;
-    else if (key == Qt::Key_PageUp)		ch = 0xF72C;
-    else if (key == Qt::Key_PageDown)	ch = 0xF72D;
-    else if (key == Qt::Key_Print)		ch = 0xF72E;
-    else if (key == Qt::Key_ScrollLock)	ch = 0xF72F;
-    else if (key == Qt::Key_Pause)		ch = 0xF730;
-    else if (key == Qt::Key_SysReq)		ch = 0xF731;
-    else if (key == Qt::Key_Stop)		ch = 0xF734;
-    else if (key == Qt::Key_Menu)		ch = 0xF735;
-    else if (key == Qt::Key_Select)		ch = 0xF741;
-    else if (key == Qt::Key_Execute)		ch = 0xF742;
-    else if (key == Qt::Key_Help)		ch = 0xF746;
-    else if (key == Qt::Key_Mode_switch)	ch = 0xF747;
-    else if (key == Qt::Key_Escape)		ch = 27;
-    else if (key == Qt::Key_Return)		ch = 13;
-    else if (key == Qt::Key_Enter)		ch = 3;
-    else if (key == Qt::Key_Tab)			ch = 9;
-    else								ch = key;
-
-    KeyboardLayoutRef layout;
-    KeyboardLayoutKind layoutKind;
-    KLGetCurrentKeyboardLayout(&layout);
-    KLGetKeyboardLayoutProperty(layout, kKLKind, const_cast<const void**>(reinterpret_cast<void**>(&layoutKind)));
-
-    if (layoutKind == kKLKCHRKind)
-    { // no Unicode available
-        if (ch > 255) return 0;
-
-        char* data;
-        KLGetKeyboardLayoutProperty(layout, kKLKCHRData, const_cast<const void**>(reinterpret_cast<void**>(&data)));
-        int ct = *reinterpret_cast<short*>(data + 258);
-        for (int i = 0; i < ct; i++)
-        {
-            char* keyTable = data + 260 + 128 * i;
-            for (int j = 0; j < 128; j++)
-            {
-                if (keyTable[j] == ch) return j;
-            }
-        }
+    switch (key)
+    {
+    case Qt::Key_Return:
+        return kVK_Return;
+    case Qt::Key_Enter:
+        return kVK_ANSI_KeypadEnter;
+    case Qt::Key_Tab:
+        return kVK_Tab;
+    case Qt::Key_Space:
+        return kVK_Space;
+    case Qt::Key_Backspace:
+        return kVK_Delete;
+    case Qt::Key_Control:
+        return kVK_Command;
+    case Qt::Key_Shift:
+        return kVK_Shift;
+    case Qt::Key_CapsLock:
+        return kVK_CapsLock;
+    case Qt::Key_Option:
+        return kVK_Option;
+    case Qt::Key_Meta:
+        return kVK_Control;
+    case Qt::Key_F17:
+        return kVK_F17;
+    case Qt::Key_VolumeUp:
+        return kVK_VolumeUp;
+    case Qt::Key_VolumeDown:
+        return kVK_VolumeDown;
+    case Qt::Key_F18:
+        return kVK_F18;
+    case Qt::Key_F19:
+        return kVK_F19;
+    case Qt::Key_F20:
+        return kVK_F20;
+    case Qt::Key_F5:
+        return kVK_F5;
+    case Qt::Key_F6:
+        return kVK_F6;
+    case Qt::Key_F7:
+        return kVK_F7;
+    case Qt::Key_F3:
+        return kVK_F3;
+    case Qt::Key_F8:
+        return kVK_F8;
+    case Qt::Key_F9:
+        return kVK_F9;
+    case Qt::Key_F11:
+        return kVK_F11;
+    case Qt::Key_F13:
+        return kVK_F13;
+    case Qt::Key_F16:
+        return kVK_F16;
+    case Qt::Key_F14:
+        return kVK_F14;
+    case Qt::Key_F10:
+        return kVK_F10;
+    case Qt::Key_F12:
+        return kVK_F12;
+    case Qt::Key_F15:
+        return kVK_F15;
+    case Qt::Key_Help:
+        return kVK_Help;
+    case Qt::Key_Home:
+        return kVK_Home;
+    case Qt::Key_PageUp:
+        return kVK_PageUp;
+    case Qt::Key_Delete:
+        return kVK_ForwardDelete;
+    case Qt::Key_F4:
+        return kVK_F4;
+    case Qt::Key_End:
+        return kVK_End;
+    case Qt::Key_F2:
+        return kVK_F2;
+    case Qt::Key_PageDown:
+        return kVK_PageDown;
+    case Qt::Key_F1:
+        return kVK_F1;
+    case Qt::Key_Left:
+        return kVK_LeftArrow;
+    case Qt::Key_Right:
+        return kVK_RightArrow;
+    case Qt::Key_Down:
+        return kVK_DownArrow;
+    case Qt::Key_Up:
+        return kVK_UpArrow;
+    default:
+        ;
+    }
+
+    if (key == Qt::Key_Escape)	ch = 27;
+    else if (key == Qt::Key_Return) ch = 13;
+    else if (key == Qt::Key_Enter) ch = 3;
+    else if (key == Qt::Key_Tab) ch = 9;
+    else ch = key;
 
+    CFDataRef currentLayoutData;
+    TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
+
+    if (currentKeyboard == NULL)
         return 0;
-    }
 
-    char* data;
-    KLGetKeyboardLayoutProperty(layout, kKLuchrData, const_cast<const void**>(reinterpret_cast<void**>(&data)));
-    UCKeyboardLayout* header = reinterpret_cast<UCKeyboardLayout*>(data);
+    currentLayoutData = (CFDataRef)TISGetInputSourceProperty(currentKeyboard, kTISPropertyUnicodeKeyLayoutData);
+    CFRelease(currentKeyboard);
+    if (currentLayoutData == NULL)
+        return 0;
+
+    UCKeyboardLayout* header = (UCKeyboardLayout*)CFDataGetBytePtr(currentLayoutData);
     UCKeyboardTypeHeader* table = header->keyboardTypeList;
 
+    uint8_t *data = (uint8_t*)header;
+    // God, would a little documentation for this shit kill you...
     for (quint32 i=0; i < header->keyboardTypeCount; i++)
     {
         UCKeyStateRecordsIndex* stateRec = 0;
@@ -159,7 +214,6 @@ quint32 QxtGlobalShortcutPrivate::nativeKeycode(Qt::Key key)
             } // for k
         } // for j
     } // for i
-
     return 0;
 }
 
