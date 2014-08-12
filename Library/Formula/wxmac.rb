require 'formula'

class Wxmac < Formula
  homepage "http://www.wxwidgets.org"
  url "https://downloads.sourceforge.net/project/wxwindows/3.0.1/wxWidgets-3.0.1.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/w/wxwidgets3.0/wxwidgets3.0_3.0.1.orig.tar.bz2"
  sha1 "73e58521d6871c9f4d1e7974c6e3a81629fddcf8"

  bottle do
    revision 6
    sha1 "fa5b9dc8ff899b0856cf806d17b18b4f40e51e29" => :mavericks
    sha1 "8b23999086a9890c5b9ee0d7af25492f6c9be158" => :mountain_lion
    sha1 "a12b5cb4322a7b8aae9fde6fdbeff4b9e3ef7cda" => :lion
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  # Patches for 3.0.1 source release to reference the correct dispatch types
  # regardless of whether built for OS X 10.10 or 10.9 (and earlier...)
  #
  # Patch derived from ticket comments and final changesets below:
  #
  #  http://trac.wxwidgets.org/ticket/16329
  #  http://trac.wxwidgets.org/changeset/76744
  #  http://trac.wxwidgets.org/changeset/76743
  #
  # NOTE: Revisit with next upstream release; changes already in upstream trunk

  # Patch Changeset 76744
  # http://trac.wxwidgets.org/changeset/76744
  patch :p3 do
    url "http://trac.wxwidgets.org/changeset/76744?format=diff&new=7674"
    sha1 "5cd1536d2494ef0b4d21f03799b0ac024572ae31"
  end

  # Patch Changeset 76743
  #
  # This is embedded because all but the last file is patchable with the changeset
  # checked into the upstream trunk (webview_webkit.mm). The version of that file
  # in trunk had changed enough that the patch cannot match any of the hunks to
  # their corresponding line numbers in the 3.0.2 release train source distribution.
  patch :DATA

  def install
    # need to set with-macosx-version-min to avoid configure defaulting to 10.5
    # need to enable universal binary build in order to build all x86_64
    # FIXME I don't believe this is the whole story, surely this can be fixed
    # without building universal for users who don't need it. - Jack
    # headers need to specify x86_64 and i386 or will try to build for ppc arch
    # and fail on newer OSes
    # https://trac.macports.org/browser/trunk/dports/graphics/wxWidgets30/Portfile#L80
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
    system "make install"
  end
end

__END__

diff -ur a/include/wx/defs.h b/include/wx/defs.h
--- a/include/wx/defs.h
+++ b/include/wx/defs.h
@@ -3169,13 +3169,20 @@
 DECLARE_WXCOCOA_OBJC_CLASS(UIEvent);
 DECLARE_WXCOCOA_OBJC_CLASS(NSSet);
 DECLARE_WXCOCOA_OBJC_CLASS(EAGLContext);
+DECLARE_WXCOCOA_OBJC_CLASS(UIWebView);
 
 typedef WX_UIWindow WXWindow;
 typedef WX_UIView WXWidget;
 typedef WX_EAGLContext WXGLContext;
 typedef WX_NSString* WXGLPixelFormat;
+typedef WX_UIWebView OSXWebViewPtr; 
 
-#endif
+#endif 
+
+#if wxOSX_USE_COCOA_OR_CARBON 
+DECLARE_WXCOCOA_OBJC_CLASS(WebView); 
+typedef WX_WebView OSXWebViewPtr; 
+#endif 
 
 #endif /* __WXMAC__ */
 
diff -ur a/include/wx/html/webkit.h b/include/wx/html/webkit.h
--- a/include/wx/html/webkit.h
+++ b/include/wx/html/webkit.h
@@ -18,7 +18,6 @@
 #endif
 
 #include "wx/control.h"
-DECLARE_WXCOCOA_OBJC_CLASS(WebView); 
 
 // ----------------------------------------------------------------------------
 // Web Kit Control
@@ -107,7 +106,7 @@
     wxString m_currentURL;
     wxString m_pageTitle;
 
-    WX_WebView m_webView;
+    OSXWebViewPtr m_webView;
 
     // we may use this later to setup our own mouse events,
     // so leave it in for now.
diff -ur a/include/wx/osx/webview_webkit.h b/include/wx/osx/webview_webkit.h
--- a/include/wx/osx/webview_webkit.h
+++ b/include/wx/osx/webview_webkit.h
@@ -158,7 +158,7 @@
     wxWindowID m_windowID;
     wxString m_pageTitle;
 
-    wxObjCID m_webView;
+    OSXWebViewPtr m_webView;
 
     // we may use this later to setup our own mouse events,
     // so leave it in for now.
diff -ur a/src/osx/webview_webkit.mm b/src/osx/webview_webkit.mm
--- a/src/osx/webview_webkit.mm	
+++ b/src/osx/webview_webkit.mm	
@@ -442,7 +442,7 @@
     if ( !m_webView )
         return;
 
-    [(WebView*)m_webView goBack];
+    [m_webView goBack];
 }
 
 void wxWebViewWebKit::GoForward()
@@ -450,7 +450,7 @@
     if ( !m_webView )
         return;
 
-    [(WebView*)m_webView goForward];
+    [m_webView goForward];
 }
 
 void wxWebViewWebKit::Reload(wxWebViewReloadFlags flags)
@@ -849,7 +849,7 @@
     if ( !m_webView )
         return;
 
-    [(WebView*)m_webView cut:m_webView];
+    [m_webView cut:m_webView];
 }
 
 void wxWebViewWebKit::Copy()
@@ -857,7 +857,7 @@
     if ( !m_webView )
         return;
 
-    [(WebView*)m_webView copy:m_webView];
+    [m_webView copy:m_webView];
 }
 
 void wxWebViewWebKit::Paste()
@@ -865,7 +865,7 @@
     if ( !m_webView )
         return;
 
-    [(WebView*)m_webView paste:m_webView];
+    [m_webView paste:m_webView];
 }
 
 void wxWebViewWebKit::DeleteSelection()
@@ -873,7 +873,7 @@
     if ( !m_webView )
         return;
 
-    [(WebView*)m_webView deleteSelection];
+    [m_webView deleteSelection];
 }
 
 bool wxWebViewWebKit::HasSelection() const
