require 'formula'

class SagittariusScheme < Formula
  homepage 'http://code.google.com/p/sagittarius-scheme/'
  url 'http://sagittarius-scheme.googlecode.com/files/sagittarius-0.4.9.tar.gz'
  sha1 '8e6a8993199fa685c35abd26af86d46b71e5195c'

  depends_on 'cmake' => :build
  depends_on 'libffi'
  depends_on 'bdw-gc'
  depends_on 'zlib'

  env :std

  def patches
    { :p1 => DATA }
  end

  fails_with :clang do
    cause 'Sagittarius Scheme cannot be built with clang'
  end

  def install
    ENV.j1 # This build isn't parallel safe.

    libffi = Formula.factory("libffi")
    cmake_system_processor = MacOS.prefer_64_bit? ? 'x86_64' : 'x86'

    ENV.no_optimization
    cmake_args = [
            '.',
            '-DCMAKE_BUILD_TYPE=None',
            '-DCMAKE_FIND_FRAMEWORK=LAST',
            '-DCMAKE_SYSTEM_NAME=darwin',
            "-DFFI_LIBRARY_DIR=#{libffi.lib}",
            "-DINSTALL_PREFIX=#{prefix}",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_SYSTEM_PROCESSOR=#{cmake_system_processor}"
    ]

    system 'cmake', *cmake_args
    system 'make'
    system 'make doc'
    system 'make test'
    system 'make install'
  end

  def test
    system "echo '(import (r7rs))' | #{bin}/sash"
  end
end

__END__
diff --git a/ext/ffi/CMakeLists.txt b/ext/ffi/CMakeLists.txt
--- a/ext/ffi/CMakeLists.txt
+++ b/ext/ffi/CMakeLists.txt
@@ -2,7 +2,22 @@
 #
 # Build file for regex

-CHECK_INCLUDE_FILE(ffi.h HAVE_FFI_H)
+IF (APPLE)
+  IF (FFI_LIBRARY_DIR)
+    MESSAGE(STATUS "Looking for ffi include directory in ${FFI_LIBRARY_DIR}")
+    FILE(GLOB FFI_INCLUDE_DIR "${FFI_LIBRARY_DIR}/libffi-*/include")
+    IF (FFI_INCLUDE_DIR)
+      MESSAGE(STATUS "Looking for ffi include directory in ${FFI_LIBRARY_DIR} - ${FFI_LIBRARY_DIR}${FFI_INCLUDE_DIR}")
+      INCLUDE_DIRECTORIES(${FFI_INCLUDE_DIR})
+      SET(HAVE_FFI_H TRUE)
+    ELSE()
+      MESSAGE(WARNING "Looking for ffi include directory in ${FFI_LIBRARY_DIR} - not found")
+    ENDIF()
+  ENDIF()
+ELSE()
+  CHECK_INCLUDE_FILE(ffi.h HAVE_FFI_H)
+ENDIF()
+
 IF (HAVE_FFI_H)
   SET(LIB_FFI_FOUND TRUE)
 ELSE()
@@ -14,7 +29,11 @@

 IF (LIB_FFI_FOUND)
   #CHECK_FUNCTION_EXISTS(ffi_prep_cif_var HAVE_FFI_PREP_CIF_VAR)
-  FIND_LIBRARY(FFI ffi)
+  IF (FFI_LIBRARY_DIR)
+    FIND_LIBRARY(FFI ffi ${FFI_LIBRARY_DIR} NO_DEFAULT_PATH)
+  ELSE()
+    FIND_LIBRARY(FFI ffi)
+  ENDIF()
   SET(LIB_FFI_LIBRARIES ${FFI})
   CHECK_LIBRARY_EXISTS(${FFI} ffi_prep_cif_var "ffi.h" HAVE_FFI_PREP_CIF_VAR)
   MESSAGE(STATUS "Sagittarius uses platform libffi")
diff --git a/ext/zlib/CMakeLists.txt b/ext/zlib/CMakeLists.txt
--- a/ext/zlib/CMakeLists.txt
+++ b/ext/zlib/CMakeLists.txt
@@ -55,6 +55,8 @@
     INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR}/zlib)
 ELSEIF()
   INCLUDE_DIRECTORIES(${ZLIB_INCLUDE_DIRS})
+  TARGET_LINK_LIBRARIES(sagittarius--zlib ${ZLIB_LIBRARIES})
+  SET(ZLIB_CONFIGURED TRUE)
 ENDIF()

 SET_TARGET_PROPERTIES(sagittarius--zlib PROPERTIES PREFIX "")
@@ -62,10 +64,12 @@
   SET_TARGET_PROPERTIES(sagittarius--zlib PROPERTIES SUFFIX ".dylib")
 ENDIF()
 TARGET_LINK_LIBRARIES(sagittarius--zlib sagittarius)
-IF (UNIX)
-  TARGET_LINK_LIBRARIES(sagittarius--zlib z)
-ELSE()
-  TARGET_LINK_LIBRARIES(sagittarius--zlib zlib)
+IF (NOT ZLIB_CONFIGURED)
+  IF (UNIX)
+    TARGET_LINK_LIBRARIES(sagittarius--zlib z)
+  ELSE()
+    TARGET_LINK_LIBRARIES(sagittarius--zlib zlib)
+  ENDIF()
 ENDIF()

 INSTALL(TARGETS sagittarius--zlib
