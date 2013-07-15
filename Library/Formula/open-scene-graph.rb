require 'formula'

class OpenSceneGraph < Formula
  homepage 'http://www.openscenegraph.org/projects/osg'
  url 'http://www.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.1.2.zip'
  sha1 '96b003aa7153b6c8e9ffc77fba13ef5d52db9cb0'
  head 'http://www.openscenegraph.org/svn/osg/OpenSceneGraph/trunk/'

  option 'ffmpeg', 'Build with ffmpeg support'
  option 'docs', 'Build the documentation with Doxygen and Graphviz'

  depends_on 'cmake' => :build
  depends_on 'jpeg'
  depends_on 'wget'
  depends_on 'gtkglext'
  depends_on 'gdal' => :optional
  depends_on 'jasper' => :optional
  depends_on 'openexr' => :optional
  depends_on 'dcmtk' => :optional
  depends_on 'librsvg' => :optional
  depends_on 'collada-dom' => :optional
  depends_on 'gnuplot' => :optional
  depends_on 'ffmpeg' if build.include? 'ffmpeg'
  depends_on 'doxygen' if build.include? 'docs'
  depends_on 'graphviz' if build.include? 'docs'


  # The mini-Boost finder in FindCOLLADA doesn't find our boost, so fix it.
  # Also CMakeLists is missing an OR plus code for 10.8.
  # Reported: http://forum.openscenegraph.org/viewtopic.php?t=10647
  # Use /usr/bin/sw_vers to determine OS version; reported upstream:
  # http://forum.openscenegraph.org/viewtopic.php?t=11878
  # Remove: Unknown. Neither fix is merged upstream yet.
  def patches
    DATA
  end

  def install
    # Turning off FFMPEG takes this change or a dozen "-DFFMPEG_" variables
    unless build.include? 'ffmpeg'
      inreplace 'CMakeLists.txt', 'FIND_PACKAGE(FFmpeg)', '#FIND_PACKAGE(FFmpeg)'
    end

    args = std_cmake_args
    args << '-DBUILD_DOCUMENTATION=' + ((build.include? 'docs') ? 'ON' : 'OFF')
    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=x86_64"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
    end
    if Formula.factory('collada-dom').installed?
      args << "-DCOLLADA_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/collada-dom"
    end
    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make'
      system 'make', 'doc_openscenegraph' if build.include? 'docs'
      system 'make install'
      if build.include? 'docs'
        doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"]
      end
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
--- a/CMakeLists.txt    2012-03-23 03:21:51.000000000 -0700
+++ b/CMakeLists.txt    2012-08-29 11:55:21.000000000 -0700
@@ -189,9 +189,11 @@ ENDIF(OSG_MAINTAINER)
 IF(NOT ANDROID)
 IF(APPLE)
     # Determine the canonical name of the selected Platform SDK
-    EXECUTE_PROCESS(COMMAND "defaults" "read" "${CMAKE_OSX_SYSROOT}/SDKSettings.plist" "CanonicalName"
+    EXECUTE_PROCESS(COMMAND "/usr/bin/sw_vers" "-productVersion"
                     OUTPUT_VARIABLE OSG_OSX_SDK_NAME
                     OUTPUT_STRIP_TRAILING_WHITESPACE)
+    STRING(SUBSTRING "${OSG_OSX_SDK_NAME}" 0 4 OSG_OSX_SDK_NAME)
+    SET(OSG_OSX_SDK_NAME "macosx${OSG_OSX_SDK_NAME}")

     # Trying to get CMake to generate an XCode IPhone project, current efforts are to get iphoneos sdk 3.1 working
     # Added option which needs manually setting to select the IPhone SDK for building. We can only have one of the below
@@ -824,16 +824,15 @@
         # FORCE is used because the options are not reflected in the UI otherwise.
         # Seems like a good place to add version specific compiler flags too.
         IF(NOT OSG_CONFIG_HAS_BEEN_RUN_BEFORE)
-            IF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.7")
+            IF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.7" OR ${OSG_OSX_SDK_NAME} STREQUAL "macosx10.8")
                 SET(OSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX "imageio" CACHE STRING "Forced imageio default image plugin for OSX" FORCE)
                 # 64 Bit Works, PPC is not supported any more
                 SET(CMAKE_OSX_ARCHITECTURES "i386;x86_64" CACHE STRING "Build architectures for OSX" FORCE)
                 SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.7 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types." FORCE)
-            ELSEIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.6" /
-                   ${OSG_OSX_SDK_NAME} STREQUAL "macosx10.5")
+            ELSEIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.6" OR ${OSG_OSX_SDK_NAME} STREQUAL "macosx10.5")
                 SET(OSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX "imageio" CACHE STRING "Forced imageio default image plugin for OSX" FORCE)
                 # 64-bit compiles are not supported with Carbon. 
-                SET(CMAKE_OSX_ARCHITECTURES "ppc;i386" CACHE STRING "Build architectures for OSX" FORCE)
+                SET(CMAKE_OSX_ARCHITECTURES "i386;x86_64" CACHE STRING "Build architectures for OSX" FORCE)
                 SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.5 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types." FORCE)
             ELSEIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.4")
                 SET(OSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX "quicktime" CACHE STRING "Forced imageio default image plugin for OSX" FORCE)
