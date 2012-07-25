require 'formula'

class Qhull < Formula
  homepage 'http://www.qhull.org/'
  url 'http://www.qhull.org/download/qhull-2012.1-src.tgz'
  sha1 '60f61580e1d6fbbd28e6df2ff625c98d15b5fbc6'

  depends_on 'cmake' => :build

  def patches
    # Patch originally from MacPorts - cosmetic edits to CMakeLists.txt:
    #
    #  * The VERSION property is no longer set on the command line tools.
    #    Setting this property causes CMake to install `binname-version` along
    #    with a symlink `binname` that points to `binname-version`. This is
    #    pointless for something that is managed by a package manager.
    # https://trac.macports.org/export/83287/trunk/dports/math/qhull/files/patch-CMakeLists.txt.diff'}
    DATA
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

__END__
--- a/CMakeLists.txt	2012-02-21 19:38:47.000000000 -0800
+++ b/CMakeLists.txt	2012-06-18 09:33:28.000000000 -0700
@@ -312,13 +312,10 @@
 # ---------------------------------------
 
 add_library(${qhull_STATIC} STATIC ${libqhull_SOURCES})
-set_target_properties(${qhull_STATIC} PROPERTIES
-    VERSION ${qhull_VERSION})
 
 add_library(${qhull_STATICP} STATIC ${libqhull_SOURCES})
 set_target_properties(${qhull_STATICP} PROPERTIES
-    COMPILE_DEFINITIONS "qh_QHpointer"
-    VERSION ${qhull_VERSION})
+    COMPILE_DEFINITIONS "qh_QHpointer")
 
 if(UNIX)
     target_link_libraries(${qhull_STATIC} m)
@@ -331,8 +328,7 @@
 
 add_library(${qhull_CPP} STATIC ${libqhullcpp_SOURCES})
 set_target_properties(${qhull_CPP} PROPERTIES
-    COMPILE_DEFINITIONS "qh_QHpointer"
-    VERSION ${qhull_VERSION})
+    COMPILE_DEFINITIONS "qh_QHpointer")
 
 # ---------------------------------------
 # Define qhull executables linked to qhullstatic library
