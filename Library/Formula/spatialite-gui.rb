class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "http://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-1.7.1.tar.gz"
  sha256 "cb9cb1ede7f83a5fc5f52c83437e556ab9cb54d6ace3c545d31b317fd36f05e4"
  revision 1

  bottle do
    cellar :any
    sha256 "d65494655bb8470c01e1ecdce00ea8802ef3b1eaebcf87ad8daf2494cbe6aa20" => :yosemite
    sha256 "dece5c5d459997cc7a8d789c38336dd4eb05e8f048f3e6eb84f581120d4ac023" => :mavericks
    sha256 "750a8216d218709d6aafd9c0fecce6342fa5ce51f3870ba844ffdd3e381c91d0" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libgaiagraphics"
  depends_on "libspatialite"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "wxmac"

  patch :DATA

  def install
    # Add aui library; reported upstream multiple times:
    # https://groups.google.com/forum/#!searchin/spatialite-users/aui/spatialite-users/wnkjK9pde2E/hVCpcndUP_wJ
    inreplace "configure", "WX_LIBS=\"$(wx-config --libs)\"", "WX_LIBS=\"$(wx-config --libs std,aui)\""
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__

For some strange reason, wxWidgets does not take the required steps to register
programs as GUI apps like other toolkits do. This necessitates the creation of
an app bundle on OS X.

This clever hack sidesteps the headache of packing simple programs into app
bundles:

  http://www.miscdebris.net/blog/2010/03/30/
    solution-for-my-mac-os-x-gui-program-doesnt-get-focus-if-its-outside-an-application-bundle
---
 Main.cpp |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Main.cpp b/Main.cpp
index a857e8a..9c90afb 100644
--- a/Main.cpp
+++ b/Main.cpp
@@ -71,6 +71,12 @@
 #define unlink	_unlink
 #endif

+#ifdef __WXMAC__
+// Allow the program to run and recieve focus without creating an app bundle.
+#include <Carbon/Carbon.h>
+extern "C" { void CPSEnableForegroundOperation(ProcessSerialNumber* psn); }
+#endif
+
 IMPLEMENT_APP(MyApp)
      bool MyApp::OnInit()
 {
@@ -86,6 +92,21 @@ IMPLEMENT_APP(MyApp)
   frame->Show(true);
   SetTopWindow(frame);
   frame->LoadConfig(path);
+
+#ifdef __WXMAC__
+  // Acquire the necessary resources to run as a GUI app without being inside
+  // an app bundle.
+  //
+  // Credit for this hack goes to:
+  //
+  //   http://www.miscdebris.net/blog/2010/03/30/solution-for-my-mac-os-x-gui-program-doesnt-get-focus-if-its-outside-an-application-bundle
+  ProcessSerialNumber psn;
+
+  GetCurrentProcess( &psn );
+  CPSEnableForegroundOperation( &psn );
+  SetFrontProcess( &psn );
+#endif
+
   return true;
 }

--
1.7.9
