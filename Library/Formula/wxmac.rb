require "formula"

class Wxmac < Formula
  homepage "http://www.wxwidgets.org"
  url "https://downloads.sourceforge.net/project/wxwindows/3.0.2/wxWidgets-3.0.2.tar.bz2"
  sha1 "6461eab4428c0a8b9e41781b8787510484dea800"

  bottle do
    sha1 "334f2813829d4529c1076c3b5598d11ad4d16506" => :mavericks
    sha1 "0f389fd69fc32d3b68cec2146710905bddbeda7c" => :mountain_lion
    sha1 "8a17d400abe57c2f26ca49809b797e305f8025f2" => :lion
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  # Various fixes related to Yosemite. Revisit in next stable release.
  # Please keep an eye on http://trac.wxwidgets.org/ticket/16329 as well
  # Theoretically the above linked patch should still be needed, but it isn't. Try to find out why.
  patch :DATA

  def install
    # need to set with-macosx-version-min to avoid configure defaulting to 10.5
    # need to enable universal binary build in order to build all x86_64
    # Jack - I don't believe this is the whole story, surely this can be fixed
    # without building universal for users who don't need it.
    # headers need to specify x86_64 and i386 or will try to build for ppc arch
    # and fail on newer OSes
    # DomT4 - MacPorts seems to have stopped building universal by default? Can we do the same?
    # https://trac.macports.org/browser/trunk/dports/graphics/wxWidgets-3.0/Portfile#L210
    ENV.universal_binary
    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-shared",
      "--enable-unicode",
      "--enable-std_string",
      "--enable-display",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-libjpeg",
      "--with-libtiff",
      # Otherwise, even in superenv, the internal libtiff can pick
      # up on a nonuniversal xz and fail
      # https://github.com/Homebrew/homebrew/issues/22732
      "--without-liblzma",
      "--with-libpng",
      "--with-zlib",
      "--enable-dnd",
      "--enable-clipboard",
      "--enable-webkit",
      "--enable-svg",
      "--enable-mediactrl",
      "--enable-graphics_ctx",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--with-expat",
      "--with-macosx-version-min=#{MacOS.version}",
      "--enable-universal_binary=#{Hardware::CPU.universal_archs.join(',')}",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic"
    ]

    system "./configure", *args
    system "make", "install"
  end
end

__END__

diff --git a/include/wx/defs.h b/include/wx/defs.h
index 397ddd7..d128083 100644
--- a/include/wx/defs.h
+++ b/include/wx/defs.h
@@ -3169,12 +3169,20 @@ DECLARE_WXCOCOA_OBJC_CLASS(UIImage);
 DECLARE_WXCOCOA_OBJC_CLASS(UIEvent);
 DECLARE_WXCOCOA_OBJC_CLASS(NSSet);
 DECLARE_WXCOCOA_OBJC_CLASS(EAGLContext);
+DECLARE_WXCOCOA_OBJC_CLASS(UIWebView);
 
 typedef WX_UIWindow WXWindow;
 typedef WX_UIView WXWidget;
 typedef WX_EAGLContext WXGLContext;
 typedef WX_NSString* WXGLPixelFormat;
 
+typedef WX_UIWebView OSXWebViewPtr;
+
+#endif
+
+#if wxOSX_USE_COCOA_OR_CARBON
+DECLARE_WXCOCOA_OBJC_CLASS(WebView);
+typedef WX_WebView OSXWebViewPtr;
 #endif
 
 #endif /* __WXMAC__ */
diff --git a/include/wx/html/webkit.h b/include/wx/html/webkit.h
index 8700367..f805099 100644
--- a/include/wx/html/webkit.h
+++ b/include/wx/html/webkit.h
@@ -18,7 +18,6 @@
 #endif
 
 #include "wx/control.h"
-DECLARE_WXCOCOA_OBJC_CLASS(WebView); 
 
 // ----------------------------------------------------------------------------
 // Web Kit Control
@@ -107,7 +106,7 @@ private:
     wxString m_currentURL;
     wxString m_pageTitle;
 
-    WX_WebView m_webView;
+    OSXWebViewPtr m_webView;
 
     // we may use this later to setup our own mouse events,
     // so leave it in for now.
diff --git a/include/wx/osx/webview_webkit.h b/include/wx/osx/webview_webkit.h
index 803f8b0..438e532 100644
--- a/include/wx/osx/webview_webkit.h
+++ b/include/wx/osx/webview_webkit.h
@@ -158,7 +158,7 @@ private:
     wxWindowID m_windowID;
     wxString m_pageTitle;
 
-    wxObjCID m_webView;
+    OSXWebViewPtr m_webView;
 
     // we may use this later to setup our own mouse events,
     // so leave it in for now.
