class Libqxt < Formula
  desc "Extension library for Qt providing a suite of utility classes"
  homepage "https://bitbucket.org/libqxt/libqxt/wiki/Home"

  stable do
    url "https://bitbucket.org/libqxt/libqxt/get/v0.6.2.tar.gz"
    sha256 "582426d6c81958dd1ac5ca4a9d49807e0a2204b7343e7d49c6613bcb148b5cb8"
    patch do
      url "https://raw.githubusercontent.com/szechyjs/patches/master/libqxt/qxtglobalshortcut_mac.cpp.diff"
      sha256 "5713b32c32843a503d33f80e7e0e2646a66012ff66130304932870c5e0e90541"
    end
  end

  head do
    url "https://bitbucket.org/libqxt/libqxt.git"
    patch :p1, :DATA
  end

  depends_on "qt"
  depends_on "berkeley-db" => :recommended

  def install
    args = ["-prefix", prefix,
            "-libdir", lib,
            "-release"]

    args << "-no-db" if build.without? "berkeley-db"

    system "./configure", *args
    system "make", "install"
  end

  test do
    true
  end
end

__END__
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
