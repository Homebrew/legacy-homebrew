require 'formula'

class SpatialiteGui < Formula
  homepage 'https://www.gaia-gis.it/fossil/spatialite_gui/index'
  url 'http://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-1.5.0-stable.tar.gz'
  sha1 'b8cfe3def8c77928f7c9fcc86bae3c99179fa486'

  devel do
    url 'http://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-1.6.0.tar.gz'
    sha1 'd06944273b1e19cdd5c17a463582e074f8548ccd'
  end

  depends_on 'libspatialite'
  depends_on 'libgaiagraphics'

  depends_on 'wxmac'

  def patches
    patch_set = {
      :p1 => DATA
    }
    # Compatibility fix for wxWidgets 2.9.x. Remove on next release.
    patch_set[:p0] = 'https://www.gaia-gis.it/fossil/spatialite_gui/vpatch?from=d8416d26358a24dc&to=b5b920d8d654dd0e' unless build.devel?

    patch_set
  end

  def install
    # This lib doesn't get picked up by configure.
    ENV.append 'LDFLAGS', '-lwx_osx_cocoau_aui-2.9'
    # 1.6.0 doesn't pick up GEOS libraries. See:
    #   https://www.gaia-gis.it/fossil/spatialite_gui/tktview?name=d27778d7e4
    ENV.append 'LDFLAGS', '-lgeos_c' if build.devel?

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
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
