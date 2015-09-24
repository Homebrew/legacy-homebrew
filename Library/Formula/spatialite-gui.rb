class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-1.7.1.tar.gz"
  sha256 "cb9cb1ede7f83a5fc5f52c83437e556ab9cb54d6ace3c545d31b317fd36f05e4"
  revision 2

  bottle do
    cellar :any
    revision 1
    sha256 "f98d8d4c09f810627a95a27880b9ee3e7c98139ff7aaaf05cde22a493c9fd11e" => :el_capitan
    sha256 "b735a2dacd313c984509a765acb47905889a2715893079da2c5a49dfea29a8f5" => :yosemite
    sha256 "b88f2f4ed62a827b6d7a70c32c15bcdc8ed52cfae39a7b4aa320f3d4b9f78109" => :mavericks
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
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

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
