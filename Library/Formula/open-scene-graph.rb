require 'formula'

class ModernClang < Requirement
  def message
    <<-EOS.undent
      OpenSceneGraph needs a modern version of clang to compile on Snow Leopard,
      but the Homebrew installed clang was not detected.  Please install it with:

                       brew install --with-clang llvm

    EOS
  end
  def satisfied?
    File.exists? "#{HOMEBREW_PREFIX}/bin/clang"
  end
  def fatal?; true; end
end

class OpenSceneGraph < Formula
  homepage 'http://www.openscenegraph.org/projects/osg'
  url 'http://www.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.1.2.zip'
  sha1 '96b003aa7153b6c8e9ffc77fba13ef5d52db9cb0'
  head 'http://www.openscenegraph.org/svn/osg/OpenSceneGraph/trunk/'

  option 'ffmpeg', 'Build with ffmpeg support'
  option 'docs', 'Build the documentation with Doxygen and Graphviz'

  depends_on ModernClang.new if MacOS.version == 10.6
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


  # 1. The mini-Boost finder in FindCOLLADA doesn't find our boost.
  # 2. The CMakeLists tries to use a `defaults read` on 10.6.8 that fails:
  #      -> https://github.com/mxcl/homebrew/issues/16076
  #    It needs to be both patched then inreplaced with the OSX version.
  # 3. Also CMakeLists has a syntax error, a missing an OR.
  # Reported: http://forum.openscenegraph.org/viewtopic.php?t=10647
  # Remove: Unknown. None are merged upstream as of osg-3.1.2.
  def patches
    DATA
  end

  def install
    # SL needs to use HB clang-3.1 or better. Nothing else works.
    if MacOS.version == 10.6
      ENV['CC'] = "#{HOMEBREW_PREFIX}/bin/clang"
      ENV['CXX'] = "#{HOMEBREW_PREFIX}/bin/clang++"
    end

    # As the second half of fixing #2 above, insert the OSX version now.
    inreplace 'CMakeLists.txt', 'SET (OSG_OSX_SDK_NAME)',
                                "SET (OSG_OSX_SDK_NAME \"macosx#{MacOS.version}\")"


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
@@ -237,7 +237,7 @@ FIND_LIBRARY(COLLADA_STATIC_LIBRARY_DEBUG
     )

     FIND_LIBRARY(COLLADA_BOOST_FILESYSTEM_LIBRARY
-        NAMES libboost_filesystem boost_filesystem libboost_filesystem-vc90-mt libboost_filesystem-vc100-mt
+        NAMES libboost_filesystem boost_filesystem boost_filesystem-mt libboost_filesystem-vc90-mt libboost_filesystem-vc100-mt
         PATHS
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/${COLLADA_BUILDNAME}
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/mingw
@@ -253,7 +253,7 @@ FIND_LIBRARY(COLLADA_STATIC_LIBRARY_DEBUG
     )

     FIND_LIBRARY(COLLADA_BOOST_SYSTEM_LIBRARY
-        NAMES libboost_system boost_system libboost_system-vc90-mt libboost_system-vc100-mt
+        NAMES libboost_system boost_system boost_system-mt libboost_system-vc90-mt libboost_system-vc100-mt
         PATHS
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/${COLLADA_BUILDNAME}
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/mingw
--- a/CMakeLists.txt	2012-03-23 03:21:51.000000000 -0700
+++ b/CMakeLists.txt	2012-11-15 16:32:12.000000000 -0800
@@ -189,9 +189,7 @@
 IF(NOT ANDROID)
 IF(APPLE)
     # Determine the canonical name of the selected Platform SDK
-    EXECUTE_PROCESS(COMMAND "defaults" "read" "${CMAKE_OSX_SYSROOT}/SDKSettings.plist" "CanonicalName"
-                    OUTPUT_VARIABLE OSG_OSX_SDK_NAME
-                    OUTPUT_STRIP_TRAILING_WHITESPACE)
+    SET (OSG_OSX_SDK_NAME)
 
     # Trying to get CMake to generate an XCode IPhone project, current efforts are to get iphoneos sdk 3.1 working
     # Added option which needs manually setting to select the IPhone SDK for building. We can only have one of the below
@@ -824,27 +824,40 @@
         # FORCE is used because the options are not reflected in the UI otherwise.
         # Seems like a good place to add version specific compiler flags too.
         IF(NOT OSG_CONFIG_HAS_BEEN_RUN_BEFORE)
+            IF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.8")
+                SET(OSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX "imageio" CACHE STRING "Forced imageio default image plugin for OSX" FORCE)
+                # 64 Bit Works, PPC is not supported any more
+                SET(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "Build architectures for OSX" FORCE)
+                SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.8 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types." FORCE)
+            ENDIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.8")
+
             IF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.7")
                 SET(OSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX "imageio" CACHE STRING "Forced imageio default image plugin for OSX" FORCE)
                 # 64 Bit Works, PPC is not supported any more
-                SET(CMAKE_OSX_ARCHITECTURES "i386;x86_64" CACHE STRING "Build architectures for OSX" FORCE)
+                SET(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "Build architectures for OSX" FORCE)
                 SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.7 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types." FORCE)
-            ELSEIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.6" /
-                   ${OSG_OSX_SDK_NAME} STREQUAL "macosx10.5")
+            ENDIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.7")
+
+            IF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.6")
                 SET(OSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX "imageio" CACHE STRING "Forced imageio default image plugin for OSX" FORCE)
                 # 64-bit compiles are not supported with Carbon. 
-                SET(CMAKE_OSX_ARCHITECTURES "ppc;i386" CACHE STRING "Build architectures for OSX" FORCE)
+                SET(CMAKE_OSX_ARCHITECTURES "i386;x86_64" CACHE STRING "Build architectures for OSX" FORCE)
+                SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.6 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types." FORCE)
+            ENDIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.6")
+
+            IF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.5")
+                SET(OSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX "imageio" CACHE STRING "Forced imageio default image plugin for OSX" FORCE)
+                # 64-bit compiles are not supported with Carbon. 
+                SET(CMAKE_OSX_ARCHITECTURES "i386;x86_64" CACHE STRING "Build architectures for OSX" FORCE)
                 SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.5 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types." FORCE)
-            ELSEIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.4")
+            ENDIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.5")
+
+            IF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.4")
                 SET(OSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX "quicktime" CACHE STRING "Forced imageio default image plugin for OSX" FORCE)
                 SET(CMAKE_OSX_ARCHITECTURES "ppc;i386" CACHE STRING "Build architectures for OSX" FORCE)
                 SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.4 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types." FORCE)
-            ELSE()
-                # No Universal Binary support
-                # Should break down further to set the -mmacosx-version-min,
-                # but the SDK detection is too unreliable here.
-            ENDIF()
-        ENDIF()
+            ENDIF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.4")
+        ENDIF(NOT OSG_CONFIG_HAS_BEEN_RUN_BEFORE)
 
         OPTION(OSG_BUILD_APPLICATION_BUNDLES "Enable the building of applications and examples as OSX Bundles" OFF)
 
--- a/src/osgViewer/CMakeLists.txt	2012-03-23 03:21:51.000000000 -0700
+++ b/src/osgViewer/CMakeLists.txt	2012-11-15 15:53:04.000000000 -0800
@@ -67,15 +67,9 @@
 
         IF(OSG_BUILD_PLATFORM_IPHONE OR OSG_BUILD_PLATFORM_IPHONE_SIMULATOR)
             SET(OSG_WINDOWING_SYSTEM "IOS" CACHE STRING "Windowing system type for graphics window creation, options only IOS.")
-        ELSE()
-            IF(${OSG_OSX_SDK_NAME} STREQUAL "macosx10.7" OR
-               ${OSG_OSX_SDK_NAME} STREQUAL "macosx10.6" OR
-               ${OSG_OSX_SDK_NAME} STREQUAL "macosx10.5")
-                SET(OSG_WINDOWING_SYSTEM "Cocoa" CACHE STRING "Windowing system type for graphics window creation, options Carbon, Cocoa or X11.")
-            ELSE()
-                SET(OSG_WINDOWING_SYSTEM "Carbon" CACHE STRING "Windowing system type for graphics window creation, options Carbon, Cocoa or X11.")
-            ENDIF()
-        ENDIF()
+        ELSE(OSG_BUILD_PLATFORM_IPHONE OR OSG_BUILD_PLATFORM_IPHONE_SIMULATOR)
+            SET(OSG_WINDOWING_SYSTEM "Cocoa" CACHE STRING "Windowing system type for graphics window creation, options Carbon, Cocoa or X11.")
+        ENDIF(OSG_BUILD_PLATFORM_IPHONE OR OSG_BUILD_PLATFORM_IPHONE_SIMULATOR)
 
     ELSE()
         IF(ANDROID)
