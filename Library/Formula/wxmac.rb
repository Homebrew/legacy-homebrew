class FrameworkPythonRequirement < Requirement
  fatal true

  satisfy do
    q = `python -c "import distutils.sysconfig as c; print(c.get_config_var('PYTHONFRAMEWORK'))"`
    !q.chomp.empty?
  end

  def message
    "Python needs to be built as a framework."
  end
end

class Wxmac < Formula
  desc "wxWidgets, a cross-platform C++ GUI toolkit (for OS X)"
  homepage "https://www.wxwidgets.org"
  url "https://downloads.sourceforge.net/project/wxwindows/3.0.2/wxWidgets-3.0.2.tar.bz2"
  sha256 "346879dc554f3ab8d6da2704f651ecb504a22e9d31c17ef5449b129ed711585d"
  revision 1

  bottle do
    cellar :any
    revision 11
    sha256 "9272643575b7db469f6cb54c61fa36a9339dd07748f3dfe7b7784994c9ce1008" => :el_capitan
    sha256 "d95d1244a39a12ca000d076d2e7dfaed6b42f1ad1540078cafabb5411f9d859f" => :yosemite
    sha256 "c9e8baf55daea9974015e61efc0719c1b4fb78a92e158b08c351d5aeb24f15b1" => :mavericks
    sha256 "59eb370bb7368a155ad3d6b7dba8536160d9d1ee6ebc67d240eb014f4a6d2dda" => :mountain_lion
  end

  option :universal
  option "with-stl", "Use standard C++ classes for everything"
  option "with-static", "Build static libraries"
  option "without-wxpython", "Don't build wxpython"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  if MacOS.version <= :snow_leopard && build.with?("wxpython")
    depends_on :python
    depends_on FrameworkPythonRequirement
  end

  link_overwrite "lib/python2.7/site-packages/wx-3.0-osx_cocoa"
  link_overwrite "lib/python2.7/site-packages/wx.pth"
  link_overwrite "lib/python2.7/site-packages/wxPython_common-3.0.2.0-py2.7.egg-info"
  link_overwrite "lib/python2.7/site-packages/wxversion.py"
  link_overwrite "lib/python2.7/site-packages/wxversion.pyc"

  # Various fixes related to Yosemite. Revisit in next stable release.
  # Please keep an eye on http://trac.wxwidgets.org/ticket/16329 as well
  # Theoretically the above linked patch should still be needed, but it isn't. Try to find out why.
  patch :DATA

  resource "wxpython" do
    url "https://downloads.sourceforge.net/project/wxpython/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
    sha256 "d54129e5fbea4fb8091c87b2980760b72c22a386cb3b9dd2eebc928ef5e8df61"
  end

  def install
    if build.with?("static") && build.with?("wxpython")
      odie "wxpython will not build against a static wxmac."
    end

    # need to set with-macosx-version-min to avoid configure defaulting to 10.5
    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
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
      # On 64-bit, enabling mediactrl leads to wxconfig trying to pull
      # in a non-existent 64 bit QuickTime framework. This is submitted
      # upstream and will eventually be fixed, but for now...
      MacOS.prefer_64_bit? ? "--disable-mediactrl" : "--enable-mediactrl",
      "--enable-graphics_ctx",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--with-expat",
      "--disable-precomp-headers",
      "--with-macosx-version-min=#{MacOS.version}",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if build.universal?
      ENV.universal_binary
      args << "--enable-universal_binary=#{Hardware::CPU.universal_archs.join(",")}"
    end

    args << "--enable-stl" if build.with? "stl"

    if build.with? "static"
      args << "--disable-shared"
    else
      args << "--enable-shared"
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "wxpython"
      resource("wxpython").stage do
        ENV["WXWIN"] = buildpath
        ENV.append_to_cflags "-arch #{MacOS.preferred_arch}" unless build.universal?

        args = [
          "WXPORT=osx_cocoa",
          # Reference our wx-config
          "WX_CONFIG=#{bin}/wx-config",
          # At this time Wxmac is installed Unicode only
          "UNICODE=1",
          # Some scripts (e.g. matplotlib) expect to `import wxversion`, which is
          # only available on a multiversion build.
          "INSTALL_MULTIVERSION=1",
          # OpenGL and stuff
          "BUILD_GLCANVAS=1",
          "BUILD_GIZMOS=1",
          "BUILD_STC=1",
        ]

        cd "wxPython" do
          system "python", "setup.py", "install", "--prefix=#{prefix}", *args
        end
      end
    end
  end

  test do
    system bin/"wx-config", "--libs"
    system "python", "-c", "import wx" if build.with? "wxpython"
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
