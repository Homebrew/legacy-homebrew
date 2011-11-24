require 'formula'

class OpenMesh < Formula
  url 'http://openmesh.org/fileadmin/openmesh-files/2.0.1/OpenMesh-2.0.1.tar.bz2'
  homepage 'http://openmesh.org'
  md5 'd1bddc97690d7fb11d873ab01f91ed60'
  head 'http://openmesh.org/svnrepo/OpenMesh/trunk/', :using => :svn

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'glew'

  def patches
    # Apply r402 from upstream SVN repository for successful install.
    # Can be removed on next stable release.
    DATA
  end

  def install
    mkdir 'openmesh-build'
    Dir.chdir 'openmesh-build' do
      system "cmake .. -DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=Release"
      system "make install"
    end
  end

  def test
    system("#{bin}/mconvert", '-help')
  end
end

__END__
Subject: Changed paths for Build to build only in Build dir,
 Disabled fixbundle until i really get a fix

---
diff --git a/cmake/ACGCommon.cmake b/cmake/ACGCommon.cmake
index cfe43a4..5d332bd 100644
--- a/cmake/ACGCommon.cmake
+++ b/cmake/ACGCommon.cmake
@@ -74,6 +74,12 @@ if (WIN32)
   if (NOT EXISTS ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR})
     file (MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR})
   endif ()
+elseif (APPLE)
+  set (ACG_PROJECT_DATADIR "share/${CMAKE_PROJECT_NAME}")
+  set (ACG_PROJECT_LIBDIR "lib/${CMAKE_PROJECT_NAME}")
+  set (CMAKE_LIBRARY_OUTPUT_DIR "${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}")
+  set (ACG_PROJECT_PLUGINDIR "lib/${CMAKE_PROJECT_NAME}/plugins")
+  set (ACG_PROJECT_BINDIR "bin")
 else ()
   set (ACG_PROJECT_DATADIR "share/${CMAKE_PROJECT_NAME}")
   set (ACG_PROJECT_LIBDIR "lib/${CMAKE_PROJECT_NAME}")
@@ -432,6 +438,15 @@ function (acg_add_library _target _libtype)
     endif ()
   endif ()

+  if( ${CMAKE_BUILD_TYPE} STREQUAL Debug )
+    set ( postfix ${CMAKE_DEBUG_POSTFIX} )
+  else ()
+    set ( postfix "" )
+  endif ()
+
+  set( fullname ${_target}${postfix} )
+
+
   if (WIN32)
     # copy exe file to "Build" directory
     # Visual studio will create this file in a subdirectory so we can't use
@@ -440,8 +455,8 @@ function (acg_add_library _target _libtype)
       add_custom_command (TARGET ${_target} POST_BUILD
                           COMMAND ${CMAKE_COMMAND} -E
                           copy_if_different
-                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${_target}.dll
-                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_BINDIR}/${_target}.dll)
+                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${fullname}.dll
+                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_BINDIR}/${fullname}.dll)
     elseif (${_type} STREQUAL MODULE)
       if (NOT EXISTS ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_PLUGINDIR})
         file (MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_PLUGINDIR})
@@ -449,23 +464,23 @@ function (acg_add_library _target _libtype)
       add_custom_command (TARGET ${_target} POST_BUILD
                           COMMAND ${CMAKE_COMMAND} -E
                           copy_if_different
-                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${_target}.dll
-                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_PLUGINDIR}/${_target}.dll)
+                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${fullname}.dll
+                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_PLUGINDIR}/${fullname}.dll)
     endif ()
     if (${_type} STREQUAL SHARED OR ${_type} STREQUAL STATIC)
       add_custom_command (TARGET ${_target} POST_BUILD
                           COMMAND ${CMAKE_COMMAND} -E
                           copy_if_different
-                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${_target}.lib
-                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/${_target}.lib)
+                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${fullname}.lib
+                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/${fullname}.lib)
     endif ()
   elseif (APPLE AND NOT ACG_PROJECT_MACOS_BUNDLE)
     if (${_type} STREQUAL SHARED)
       add_custom_command (TARGET ${_target} POST_BUILD
                           COMMAND ${CMAKE_COMMAND} -E
                           copy_if_different
-                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}.dylib
-                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/lib${_target}.dylib)
+                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${fullname}.dylib
+                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/lib${fullname}.dylib)
     elseif (${_type} STREQUAL MODULE)
       if (NOT EXISTS ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_PLUGINDIR})
         file (MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_PLUGINDIR})
@@ -473,29 +488,29 @@ function (acg_add_library _target _libtype)
       add_custom_command (TARGET ${_target} POST_BUILD
                           COMMAND ${CMAKE_COMMAND} -E
                           copy_if_different
-                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}.so
-                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_PLUGINDIR}/lib${_target}.so)
+                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${fullname}.so
+                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_PLUGINDIR}/lib${fullname}.so)
     elseif (${_type} STREQUAL STATIC)
       add_custom_command (TARGET ${_target} POST_BUILD
                           COMMAND ${CMAKE_COMMAND} -E
                           copy_if_different
-                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}.a
-                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/lib${_target}.a)
+                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${fullname}.a
+                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/lib${fullname}.a)
     endif ()
     if (_and_static)
       add_custom_command (TARGET ${_target}Static POST_BUILD
                           COMMAND ${CMAKE_COMMAND} -E
                           copy_if_different
-                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}Static.a
-                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/lib${_target}.a)
+                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}Static${postfix}.a
+                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/lib${fullname}.a)
     endif ()

   elseif (NOT APPLE AND _and_static)
       add_custom_command (TARGET ${_target}Static POST_BUILD
                           COMMAND ${CMAKE_COMMAND} -E
                           copy_if_different
-                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}Static.a
-                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/lib${_target}.a)
+                            ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}Static${postfix}.a
+                            ${CMAKE_BINARY_DIR}/Build/${ACG_PROJECT_LIBDIR}/lib${fullname}.a)

   endif ()

@@ -509,9 +524,9 @@ function (acg_add_library _target _libtype)
                  LIBRARY DESTINATION ${ACG_PROJECT_LIBDIR}
                  ARCHIVE DESTINATION ${ACG_PROJECT_LIBDIR})
         if (_and_static)
-          install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}Static.a
+          install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib${_target}Static${postfix}.a
                    DESTINATION ${ACG_PROJECT_LIBDIR}
-                   RENAME lib${_target}.a
+                   RENAME lib${fullname}.a
                    PERMISSIONS OWNER_WRITE OWNER_READ OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
         endif ()
       elseif (${_type} STREQUAL MODULE)
diff --git a/cmake/fixbundle.cmake.in b/cmake/fixbundle.cmake.in
index bd20820..8b3b32e 100644
--- a/cmake/fixbundle.cmake.in
+++ b/cmake/fixbundle.cmake.in
@@ -39,19 +39,24 @@ endfunction(gp_item_default_embedded_path_override)

 include (BundleUtilities)

-# copy qt plugins to bundle
-file (GLOB _plugins "@CMAKE_BINARY_DIR@/Build/OpenFlipper.app/Contents/Resources/Plugins/*.so")
-file (GLOB_RECURSE _qtplugins "@QT_PLUGINS_DIR@/*.bundle")
-foreach (_qtp ${_qtplugins})
-  get_filename_component(_dir "${_qtp}" PATH)
-  list(APPEND _qtdirs "${_dir}")
-endforeach ()
-
-# Get library paths
-get_filename_component(_GlutDir "@GLUT_glut_LIBRARY@" PATH)
-
-# fix all dependencies
-fixup_bundle (@CMAKE_BINARY_DIR@/Build/bin/QtViewer "${_qtplugins}" "/usr/lib;${_qtdirs};${_GlutDir}")
+#if ( @BUILD_APPS@ )
+#  message("Fixing up bundle ...")
+#
+#  # copy qt plugins to bundle
+#  file (GLOB _plugins "@CMAKE_BINARY_DIR@/Build/OpenFlipper.app/Contents/Resources/Plugins/*.so")
+#  file (GLOB_RECURSE _qtplugins "@QT_PLUGINS_DIR@/*.bundle")
+#  foreach (_qtp ${_qtplugins})
+#    get_filename_component(_dir "${_qtp}" PATH)
+#    list(APPEND _qtdirs "${_dir}")
+#  endforeach ()
+
+#  # Get library paths
+#  get_filename_component(_GlutDir "@GLUT_glut_LIBRARY@" PATH)
+
+#  # fix all dependencies
+#  fixup_bundle (@CMAKE_BINARY_DIR@/Build/bin/QtViewer "${_qtplugins}" "/usr/lib;${_qtdirs};${_GlutDir}")
+#
+#endif()

 # create qt plugin configuration file
 # file(WRITE "@CMAKE_BINARY_DIR@/Build/OpenMesh.app/Contents/Resources/qt.conf" "[Paths]\nPlugins = Resources/QtPlugins")
