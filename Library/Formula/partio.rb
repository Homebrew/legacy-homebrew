require 'formula'

class Partio < Formula
  homepage 'http://www.partio.us'
  url 'http://githubredir.debian.net/github/wdas/partio/v1.1.0.tar.gz'
  sha1 '4afbc41298e198c8606716474898ad0ae0b858ee'

  depends_on 'cmake' => :build
  depends_on 'swig' => :build
  depends_on 'doxygen' => :build

  def patches
    # cmake: Allow users to specify CMAKE_INSTALL_PREFIX 
    # cmake: Do not hard-code the path to doxygen
    # cmake: Allow out-of-tree builds
    DATA
  end

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make doc"
      system "make install"
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index e331c9c..ae11f76 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -75,9 +75,10 @@ IF(NOT CMAKE_BUILD_TYPE)
 ENDIF(NOT CMAKE_BUILD_TYPE)
 
 ## Set install location
-EXECUTE_PROCESS(COMMAND sh -c "echo `uname`-`uname -r | cut -d'-' -f1`-`uname -m`" OUTPUT_VARIABLE VARIANT_DIRECTORY OUTPUT_STRIP_TRAILING_WHITESPACE)
-#EXECUTE_PROCESS(COMMAND uname OUTPUT_VARIABLE VARIANT_DIRECTORY OUTPUT_STRIP_TRAILING_WHITESPACE)
-SET(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/${VARIANT_DIRECTORY}")
+IF (NOT DEFINED CMAKE_INSTALL_PREFIX)
+    EXECUTE_PROCESS(COMMAND sh -c "echo `uname`-`uname -r | cut -d'-' -f1`-`uname -m`" OUTPUT_VARIABLE VARIANT_DIRECTORY OUTPUT_STRIP_TRAILING_WHITESPACE)
+    SET(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/${VARIANT_DIRECTORY}")
+ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
 
 ## Search for useful libraries
 find_package(GLUT REQUIRED)
diff --git a/src/doc/CMakeLists.txt b/src/doc/CMakeLists.txt
index 143725a..0db3db6 100644
--- a/src/doc/CMakeLists.txt
+++ b/src/doc/CMakeLists.txt
@@ -40,6 +40,6 @@ IF(DOXYGEN_FOUND)
     COMMENT "Generating API documentation with Doxygen" VERBATIM)
   add_dependencies(doc DOCUMENTED_FILES)
   
-  ADD_CUSTOM_TARGET(${HTML_TARGET} ALL /usr/bin/doxygen ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile)
+  ADD_CUSTOM_TARGET(${HTML_TARGET} ALL ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile)
   INSTALL( DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html/ DESTINATION share/doc/partio )
 ENDIF(DOXYGEN_FOUND)
diff --git a/src/py/CMakeLists.txt b/src/py/CMakeLists.txt
index 7275ca5..dac8556 100644
--- a/src/py/CMakeLists.txt
+++ b/src/py/CMakeLists.txt
@@ -40,7 +40,7 @@ IF(PYTHONLIBS_FOUND)
 
 INCLUDE(${SWIG_USE_FILE})
 
-EXECUTE_PROCESS( COMMAND python -c "import sys;print"%s.%s"%sys.version_info[0:2]" OUTPUT_VARIABLE PYTHON_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
+EXECUTE_PROCESS( COMMAND python -c "import sys;print'%s.%s'%sys.version_info[0:2]" OUTPUT_VARIABLE PYTHON_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
 
 
 INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})
@@ -58,9 +58,9 @@ SET_SOURCE_FILES_PROPERTIES(partio.i PROPERTIES SWIG_FLAGS "-includeall")
 SWIG_ADD_MODULE(partio python partio.i)
 SWIG_LINK_LIBRARIES(partio ${PYTHON_LIBRARIES} ${ZLIB_LIBRARY} partio)
 
-SET(PYTHON_DEST "lib64/python${PYTHON_VERSION}/site-packages" )
+SET(PYTHON_DEST "lib/python${PYTHON_VERSION}/site-packages" )
 INSTALL(TARGETS _partio DESTINATION ${PYTHON_DEST})
-INSTALL(FILES ${CMAKE_BINARY_DIR}/${outdir}/src/py/partio.py  DESTINATION ${PYTHON_DEST})
+INSTALL(FILES ${CMAKE_BINARY_DIR}/${outdir}/py/partio.py  DESTINATION ${PYTHON_DEST})
 
 ENDIF(PYTHONLIBS_FOUND)
 ENDIF(SWIG_FOUND)

