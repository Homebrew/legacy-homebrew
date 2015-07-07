require 'formula'

class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage 'http://plplot.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/plplot/plplot/5.10.0%20Source/plplot-5.10.0.tar.gz'
  sha1 'ea962cb0138c9b4cbf97ecab1fac1919ea0f939f'

  bottle do
    revision 1
    sha256 "c7721f7d2cd4aa9f9e9724bb7e97dbeadcbafe9e9d3f331a56a97986b88bf896" => :yosemite
    sha256 "394ee113bdf444ec5c2a50fd379f283cfa85de3a6d04fe7a673a2e8c211c2264" => :mavericks
    sha256 "39b18e81232ae3987018662035c49a441ddd0f0fcbe9d7534620d512b7f2910c" => :mountain_lion
  end

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on :x11 => :optional

  option 'with-java'

  # patch 1 taken from upstream http://sourceforge.net/p/plplot/plplot/ci/772223c638ecf5dc740c9f3dd7a6883c6d2c83d2
  # fixes https://github.com/Homebrew/homebrew/issues/36569
  #
  # patch 2 taken from upstream http://sourceforge.net/p/plplot/plplot/ci/467c0b0ef58b1759238d7ec3551e3e3fe8f36c5b
  # fixes possible compilation problems involving the use of HAVE_CONFIG_H
  patch :DATA

  def install
    args = std_cmake_args
    args << '-DPLD_wxwidgets=OFF' << '-DENABLE_wxwidgets=OFF'
    args << '-DENABLE_java=OFF' if build.without? 'java'
    args << '-DPLD_xcairo=OFF' if build.without? 'x11'
    args << '-DENABLE_ada=OFF'
    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end

__END__
--- a/cmake/modules/pkg-config.cmake
+++ b/cmake/modules/pkg-config.cmake
@@ -1,6 +1,6 @@
 # cmake/modules/pkg-config.cmake
 #
-# Copyright (C) 2006  Alan W. Irwin
+# Copyright (C) 2006-2015 Alan W. Irwin
 #
 # This file is part of PLplot.
 #
@@ -94,7 +94,12 @@
     set(_xprefix ${_prefix})
   endif(FORCE_EXTERNAL_STATIC)
   
-  _pkg_check_modules_internal(0 0 ${_prefix} "${_package}")
+  if(CMAKE_VERSION VERSION_LESS "3.1")
+    _pkg_check_modules_internal(0 0 ${_prefix} "${_package}")
+  else(CMAKE_VERSION VERSION_LESS "3.1")
+    _pkg_check_modules_internal(0 0 0 0 ${_prefix} "${_package}")
+  endif(CMAKE_VERSION VERSION_LESS "3.1")
+    
   if(${_prefix}_FOUND)
     cmake_link_flags(${_link_FLAGS} "${${_xprefix}_LDFLAGS}")
     # If libraries cannot be not found, then that is equivalent to whole
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -125,7 +125,7 @@ configure_file(
   ${CMAKE_CURRENT_BINARY_DIR}/plplot_config.h
   )
 # Allow access to the generated plplot_config.h for this build.
-add_definitions("-DHAVE_CONFIG_H")
+add_definitions("-DPLPLOT_HAVE_CONFIG_H")
 # Install top-level files

 # Enable testing framework for examples
@@ -206,10 +206,6 @@ if(PREBUILD_DIST)
   # List of targets that must be (pre-)built.
   set(DIST_TARGETS)

-  if(ENABLE_octave)
-    list(APPEND DIST_TARGETS make_documentation)
-  endif(ENABLE_octave)
-
   if(BUILD_PRINT)
     list(APPEND DIST_TARGETS print)
   endif(BUILD_PRINT)
@@ -239,11 +235,6 @@ if(PREBUILD_DIST)
     add_custom_target(
       prebuild_dist
       COMMAND ${CMAKE_COMMAND} -E remove_directory
-      ${CMAKE_SOURCE_DIR}/bindings/octave/plplot_octave_txt
-      COMMAND ${CMAKE_COMMAND} -E copy_directory
-      ${CMAKE_BINARY_DIR}/bindings/octave/plplot_octave_txt
-      ${CMAKE_SOURCE_DIR}/bindings/octave/plplot_octave_txt
-      COMMAND ${CMAKE_COMMAND} -E remove_directory
       ${CMAKE_SOURCE_DIR}/doc/doxygen
       COMMAND ${CMAKE_COMMAND} -E copy_directory
       ${CMAKE_BINARY_DIR}/doc/doxygen
diff --git a/bindings/ocaml/CMakeLists.txt b/bindings/ocaml/CMakeLists.txt
index e45988e..ff392f0 100644
--- a/bindings/ocaml/CMakeLists.txt
+++ b/bindings/ocaml/CMakeLists.txt
@@ -57,16 +57,15 @@ if(ENABLE_ocaml)
   if(GENERATE_PLPLOT_H_INC)
     add_custom_target(
       check_plplot_h.inc
-      COMMAND 
-      ${CMAKE_COMMAND} -E remove -f ${CMAKE_CURRENT_BINARY_DIR}/generated_plplot_h.inc
-      COMMAND
-      ${OCAML} ${CMAKE_CURRENT_SOURCE_DIR}/touchup.ml ${CMAKE_CURRENT_SOURCE_DIR}/plplot_h ${CMAKE_CURRENT_BINARY_DIR}/generated_plplot_h.inc
-      COMMAND
-      ${CMAKE_COMMAND} -E echo "Check that plplot_h.inc is consistent with touchup.ml and plplot_h"
-      COMMAND
-      cmp ${CMAKE_CURRENT_SOURCE_DIR}/plplot_h.inc ${CMAKE_CURRENT_BINARY_DIR}/generated_plplot_h.inc
+      COMMAND ${CMAKE_COMMAND} -E echo "Check that bindings/ocaml/plplot_h.inc is consistent with bindings/ocaml/touchup.ml and bindings/ocaml/plplot_h"
+      COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_CURRENT_BINARY_DIR}/generated_plplot_h.inc
+      COMMAND ${OCAML} ${CMAKE_CURRENT_SOURCE_DIR}/touchup.ml ${CMAKE_CURRENT_SOURCE_DIR}/plplot_h ${CMAKE_CURRENT_BINARY_DIR}/generated_plplot_h.inc
+      COMMAND cmp ${CMAKE_CURRENT_SOURCE_DIR}/plplot_h.inc ${CMAKE_CURRENT_BINARY_DIR}/generated_plplot_h.inc
       WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
       )
+
+    add_dependencies(check_all check_plplot_h.inc)
+
   endif(GENERATE_PLPLOT_H_INC)

   #Detailed CMake logic to build ocaml bindings for PLplot.
@@ -99,7 +98,7 @@ if(ENABLE_ocaml)
     ${CMAKE_CURRENT_BINARY_DIR}/dllplplot_stubs.so
     ${CMAKE_CURRENT_BINARY_DIR}/libplplot_stubs.a
     COMMAND ${OCAMLC} -ccopt -I${CAMLIDL_LIB_DIR} -c ${CMAKE_CURRENT_BINARY_DIR}/plplot_core_stubs.c
-    COMMAND ${OCAMLC} -ccopt -I${CMAKE_SOURCE_DIR}/include -ccopt -I${CMAKE_BINARY_DIR}/include -ccopt -I${CMAKE_SOURCE_DIR}/lib/qsastime -ccopt -I${CMAKE_BINARY_DIR} -ccopt -I${CAMLIDL_LIB_DIR} -ccopt -DHAVE_CONFIG_H -c ${CMAKE_CURRENT_SOURCE_DIR}/plplot_impl.c
+    COMMAND ${OCAMLC} -ccopt -I${CMAKE_SOURCE_DIR}/include -ccopt -I${CMAKE_BINARY_DIR}/include -ccopt -I${CMAKE_SOURCE_DIR}/lib/qsastime -ccopt -I${CMAKE_BINARY_DIR} -ccopt -I${CAMLIDL_LIB_DIR} -ccopt -DPLPLOT_HAVE_CONFIG_H -c ${CMAKE_CURRENT_SOURCE_DIR}/plplot_impl.c
     COMMAND ${OCAMLMKLIB} -o plplot_stubs -L${CAMLIDL_LIB_DIR} -lcamlidl -L${CMAKE_BINARY_DIR}/src -lplplot${LIB_TAG} ${CMAKE_CURRENT_BINARY_DIR}/plplot_core_stubs.o ${CMAKE_CURRENT_BINARY_DIR}/plplot_impl.o ${ocaml_STATIC_FLAGS}
     DEPENDS
     ${CMAKE_CURRENT_BINARY_DIR}/plplot_core_stubs.c
diff --git a/bindings/ocaml/plcairo/CMakeLists.txt b/bindings/ocaml/plcairo/CMakeLists.txt
index 423ef80..d98acf5 100644
--- a/bindings/ocaml/plcairo/CMakeLists.txt
+++ b/bindings/ocaml/plcairo/CMakeLists.txt
@@ -36,7 +36,7 @@ if(ENABLE_ocaml AND OCAML_HAS_CAIRO)
     ${CMAKE_CURRENT_BINARY_DIR}/plcairo_impl.o
     ${CMAKE_CURRENT_BINARY_DIR}/dllplcairo_stubs.so
     ${CMAKE_CURRENT_BINARY_DIR}/libplcairo_stubs.a
-    COMMAND ${OCAMLC} -ccopt "${CAIRO_COMPILE_FLAGS}" -cclib "${CAIRO_LINK_FLAGS}" -ccopt -I${CMAKE_SOURCE_DIR}/include -ccopt -I${CMAKE_BINARY_DIR}/include -ccopt -I${CMAKE_SOURCE_DIR}/lib/qsastime  -ccopt -I${CMAKE_BINARY_DIR} -ccopt -DHAVE_CONFIG_H -c ${CMAKE_CURRENT_SOURCE_DIR}/plcairo_impl.c
+    COMMAND ${OCAMLC} -ccopt "${CAIRO_COMPILE_FLAGS}" -cclib "${CAIRO_LINK_FLAGS}" -ccopt -I${CMAKE_SOURCE_DIR}/include -ccopt -I${CMAKE_BINARY_DIR}/include -ccopt -I${CMAKE_SOURCE_DIR}/lib/qsastime  -ccopt -I${CMAKE_BINARY_DIR} -ccopt -DPLPLOT_HAVE_CONFIG_H -c ${CMAKE_CURRENT_SOURCE_DIR}/plcairo_impl.c
     COMMAND ${OCAMLMKLIB} -o plcairo_stubs ${CAIRO_LINK_FLAGS_LIST} -L${CMAKE_BINARY_DIR}/src -lplplot${LIB_TAG} ${CMAKE_CURRENT_BINARY_DIR}/plcairo_impl.o
     DEPENDS
     ${CMAKE_CURRENT_SOURCE_DIR}/plcairo_impl.c
diff --git a/include/plConfig.h.in b/include/plConfig.h.in
index 0d63dd0..27ce48b 100644
--- a/include/plConfig.h.in
+++ b/include/plConfig.h.in
@@ -30,7 +29,7 @@
 // any user applications).  Therefore, the configured plConfig.h
 // should be installed.  In contrast, plplot_config.h.in (note,
 // plConfig.h #includes plplot_config.h for the core build because
-// HAVE_CONFIG_H is #defined in that case) contains configured macros
+// PLPLOT_HAVE_CONFIG_H is #defined in that case) contains configured macros
 // that are only required for the core build.  Therefore, in contrast
 // to plConfig.h, plplot_config.h should not be installed.
 //
@@ -44,10 +43,16 @@
 #ifndef __PLCONFIG_H__
 #define __PLCONFIG_H__

-#ifdef HAVE_CONFIG_H
+#ifdef PLPLOT_HAVE_CONFIG_H
 #  include <plplot_config.h>
 #endif

+// PLplot version information.
+#define PLPLOT_VERSION_MAJOR    "@PLPLOT_VERSION_MAJOR@"
+#define PLPLOT_VERSION_MINOR    "@PLPLOT_VERSION_MINOR@"
+#define PLPLOT_VERSION_PATCH    "@PLPLOT_VERSION_PATCH@"
+#define PLPLOT_VERSION          "@PLPLOT_VERSION@"
+
 // Define if you have c++ accessible stdint.h
 #cmakedefine PL_HAVE_CXX_STDINT_H

diff --git a/plplot_config.h.in b/plplot_config.h.in
index 0274dc8..25e9472 100644
--- a/plplot_config.h.in
+++ b/plplot_config.h.in
@@ -3,7 +3,7 @@
 // examples (and presumably any user applications).  Therefore, the
 // configured plplot_config.h should not be installed.  In contrast,
 // include/plConfig.h.in (note, the configured plConfig.h result
-// #includes plplot_config.h for the core build because HAVE_CONFIG_H
+// #includes plplot_config.h for the core build because PLPLOT_HAVE_CONFIG_H
 // is #defined in that case) contains configured macros that are
 // required for the core build, installed examples build, and build of
 // user applications.  Therefore, in contrast to plplot_config.h,
@@ -282,9 +282,6 @@
 // Define to 1 if you have the ANSI C header files.
 #cmakedefine STDC_HEADERS 1

-// Overall PLplot version number
-#define PLPLOT_VERSION             "@PLPLOT_VERSION@"
-
 // Location of Tcl stuff
 #define TCL_DIR                    "@TCL_DIR@"
 // Consistent package versions for Itcl and friends found by PLplot
@@ -309,3 +306,6 @@

 // Define as `fork' if `vfork' does not work.
 #cmakedefine vfork
+
+// Define if the PLplot build uses Qt5 (rather than Qt4).
+#cmakedefine PLPLOT_USE_QT5
