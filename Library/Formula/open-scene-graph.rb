require 'formula'

class OpenSceneGraph < Formula
  homepage 'http://www.openscenegraph.org/projects/osg'
  url 'http://www.openscenegraph.org/downloads/stable_releases/OpenSceneGraph-3.0.1/source/OpenSceneGraph-3.0.1.zip'
  md5 'c43a25d023e635c3566b2083d8e6d956'
  head 'http://www.openscenegraph.org/svn/osg/OpenSceneGraph/trunk/'

  depends_on 'cmake' => :build
  depends_on 'jpeg'
  depends_on 'wget'
  depends_on 'ffmpeg' => :optional
  depends_on 'gdal' => :optional
  depends_on 'jasper' => :optional
  depends_on 'openexr' => :optional
  depends_on 'dcmtk' => :optional
  depends_on 'librsvg' => :optional
  depends_on 'collada-dom' => :optional

  devel do
    url 'http://www.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.1.1.zip'
    md5 '079b9c1738057227b1804c6698fc9c89'
  end

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      cannot initialize a parameter of type 'void *' with an lvalue of type 'const void *const'
      http://forum.openscenegraph.org/viewtopic.php?t=10042
      EOS
  end

  # First patch: The mini-Boost finder in FindCOLLADA doesn't find our boost, so fix it.
  # Second patch:
  # Lion replacement for CGDisplayBitsPerPixel();
  # taken from: http://www.openscenegraph.org/projects/osg/changeset/12790/OpenSceneGraph/trunk/src/osgViewer/DarwinUtils.mm
  # Issue at: https://github.com/mxcl/homebrew/issues/11391
  # should be obsolete with some newer versions (current version is: 3.0.1)
  def patches; DATA; end

  def install
    args = %W{
      ..
      -DCMAKE_INSTALL_PREFIX='#{prefix}'
      -DCMAKE_BUILD_TYPE=None
      -Wno-dev
      -DBUILD_OSG_WRAPPERS=ON
      -DBUILD_DOCUMENTATION=ON
    }

    if snow_leopard_64?
      args << "-DCMAKE_OSX_ARCHITECTURES=x86_64"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
    end

    if Formula.factory('collada-dom').installed?
      args << "-DCOLLADA_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/collada-dom"
    end

    mkdir "build" do
      system "cmake", *args
      system "make install"
    end
  end

end

__END__
diff --git a/CMakeModules/FindCOLLADA.cmake b/CMakeModules/FindCOLLADA.cmake
index 428cb29..6206580 100644
--- a/CMakeModules/FindCOLLADA.cmake
+++ b/CMakeModules/FindCOLLADA.cmake
@@ -235,7 +235,7 @@ FIND_LIBRARY(COLLADA_STATIC_LIBRARY_DEBUG
     )

     FIND_LIBRARY(COLLADA_BOOST_FILESYSTEM_LIBRARY
-        NAMES libboost_filesystem boost_filesystem libboost_filesystem-vc90-mt libboost_filesystem-vc100-mt
+        NAMES libboost_filesystem boost_filesystem boost_filesystem-mt libboost_filesystem-vc90-mt libboost_filesystem-vc100-mt
         PATHS
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/${COLLADA_BUILDNAME}
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/mingw
@@ -251,7 +251,7 @@ FIND_LIBRARY(COLLADA_STATIC_LIBRARY_DEBUG
     )

     FIND_LIBRARY(COLLADA_BOOST_SYSTEM_LIBRARY
-        NAMES libboost_system boost_system libboost_system-vc90-mt libboost_system-vc100-mt
+        NAMES libboost_system boost_system boost_system-mt libboost_system-vc90-mt libboost_system-vc100-mt
         PATHS
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/${COLLADA_BUILDNAME}
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/mingw


Index: OpenSceneGraph/trunk/src/osgViewer/DarwinUtils.mm
===================================================================
--- a/src/osgViewer/DarwinUtils.mm (revision 12292)
+++ b/src/osgViewer/DarwinUtils.mm (revision 12790)
@@ -48,4 +48,23 @@
 namespace osgDarwin {
 
+//
+// Lion replacement for CGDisplayBitsPerPixel(CGDirectDisplayID displayId)
+//
+size_t displayBitsPerPixel( CGDirectDisplayID displayId )
+{
+
+    CGDisplayModeRef mode = CGDisplayCopyDisplayMode(displayId);
+    size_t depth = 0;
+
+    CFStringRef pixEnc = CGDisplayModeCopyPixelEncoding(mode);
+    if(CFStringCompare(pixEnc, CFSTR(IO32BitDirectPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo)
+        depth = 32;
+    else if(CFStringCompare(pixEnc, CFSTR(IO16BitDirectPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo)
+        depth = 16;
+    else if(CFStringCompare(pixEnc, CFSTR(IO8BitIndexedPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo)
+        depth = 8;
+
+    return depth;
+}
 
 static inline CGRect toCGRect(NSRect nsRect)
@@ -314,5 +333,5 @@
     resolution.width = CGDisplayPixelsWide(id);
     resolution.height = CGDisplayPixelsHigh(id);
-    resolution.colorDepth = CGDisplayBitsPerPixel(id);
+    resolution.colorDepth = displayBitsPerPixel(id);
     resolution.refreshRate = getDictDouble (CGDisplayCurrentMode(id), kCGDisplayRefreshRate);        // Not tested
     if (resolution.refreshRate<0) resolution.refreshRate = 0;
@@ -403,5 +422,5 @@
         CGDisplayBestModeForParametersAndRefreshRate(
                         displayid, 
-                        CGDisplayBitsPerPixel(displayid), 
+                        displayBitsPerPixel(displayid), 
                         width, height,  
                         refresh,  
@@ -433,5 +452,5 @@
         CGDisplayBestModeForParametersAndRefreshRate(
                         displayid, 
-                        CGDisplayBitsPerPixel(displayid), 
+                        displayBitsPerPixel(displayid), 
                         width, height,  
                         refreshRate,  
