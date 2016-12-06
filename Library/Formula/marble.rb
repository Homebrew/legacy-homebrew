require 'formula'

class Marble < Formula
  homepage 'http://edu.kde.org/marble'
  url 'http://download.kde.org/stable/4.8.3/src/marble-4.8.3.tar.xz'
  md5 '4e9b84a0d29dc5734bc7f11e5855e16e'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def patches
    DATA
  end

  def install
    system "cmake #{std_cmake_parameters} -DQTONLY=ON"
    system "make install" # if this fails, try separate make/make install steps
  end
end

__END__
#Patch to disable architecture forcing (https://git.reviewboard.kde.org/r/104942/
--- a/CMakeLists.txt	2012-05-12 15:05:14.000000000 +0200
+++ b/CMakeLists.txt	2012-05-12 15:05:21.000000000 +0200
@@ -155,8 +155,9 @@
       SET( MACOSX_BUNDLE_VERSION 0.3.0 )
       SET( MACOSX_BUNDLE_LONG_VERSION_STRING Version 0.3.0 )
       SET( MACOSX_BUNDLE_BUNDLE_NAME Marble)
-      #SET( CMAKE_OSX_ARCHITECTURES ppc;i386 ) #Comment out if not universal binary
-      SET( CMAKE_OSX_ARCHITECTURES i386 ) #Comment out if universal binary
+      if (MACOSX_UNIVERSAL)
+        SET( CMAKE_OSX_ARCHITECTURES ppc;i386 ) #Comment out if not universal binary
+      endif(MACOSX_UNIVERSAL)
       #SET (lib_dir ${CMAKE_INSTALL_PREFIX}/Marble.app/Contents/MacOS/lib)
       SET (data_dir   ${CMAKE_INSTALL_PREFIX}/Marble.app/Contents/MacOS/resources/data)
       SET (plugin_dir   ${CMAKE_INSTALL_PREFIX}/Marble.app/Contents/MacOS/resources/plugins)
#Patch to set the appropiate path for cmake modules (required for digikam)
diff --git a/CMakeLists.txt b/CMakeLists.txt
index ebf41b9..86ff26a 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -161,9 +161,11 @@ else(WIN32)
       #SET (lib_dir ${CMAKE_INSTALL_PREFIX}/Marble.app/Contents/MacOS/lib)
       SET (data_dir   ${CMAKE_INSTALL_PREFIX}/Marble.app/Contents/MacOS/resources/data)
       SET (plugin_dir   ${CMAKE_INSTALL_PREFIX}/Marble.app/Contents/MacOS/resources/plugins)
+      set(CMAKE_MODULES_INSTALL_PATH ${CMAKE_ROOT}/Modules)
     else (QTONLY) # KDE4 on Mac...
       set(data_dir ${DATA_INSTALL_DIR}/marble/data)
       set(plugin_dir ${PLUGIN_INSTALL_DIR}/plugins/marble)
+      set(CMAKE_MODULES_INSTALL_PATH ${DATA_INSTALL_DIR}/cmake/modules)
     endif (QTONLY)
   else(APPLE) # Linux / bsd etc...
     if (QTONLY)
