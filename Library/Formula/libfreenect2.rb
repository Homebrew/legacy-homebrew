class Libfreenect2 < Formula
  desc "Drivers/Example for Kinect V2"
  homepage "https://github.com/OpenKinect/libfreenect2"
  url "https://github.com/ybott/libfreenect2/archive/v0.0.1-alpha.tar.gz"
  sha256 "704572b2848c38499ef934d9445d275033eb94d245aa60706eea2179ab2629c2"

  depends_on "libusb"
  depends_on "nasm" => :optional
  depends_on "jpeg-turbo" => :optional
  depends_on "homebrew/science/opencv" => :optional
  depends_on "homebrew/versions/glfw3" => :optional
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  patch :DATA

  def install
    system "cmake", "examples/protonect", *std_cmake_args
    system "make"
    system "make", "install"
  end
end

__END__
diff --git a/examples/protonect/CMakeLists.txt b/examples/protonect/CMakeLists.txt
index ba93a67..a38fd9f 100644
--- a/examples/protonect/CMakeLists.txt
+++ b/examples/protonect/CMakeLists.txt
@@ -202,4 +202,4 @@ IF(LIBFREENECT2_THREADING_TINYTHREAD)
 ENDIF(LIBFREENECT2_THREADING_TINYTHREAD)
 INSTALL(FILES "${PROJECT_BINARY_DIR}/freenect2Config.cmake" DESTINATION lib/cmake/freenect2/)
 INSTALL(FILES "${PROJECT_BINARY_DIR}/freenect2.pc" DESTINATION lib/pkgconfig/)
-  
+INSTALL(FILES "${MY_DIR}/bin/Protonect" DESTINATION bin/)
diff --git a/examples/protonect/cmake_modules/FindLibUSB.cmake b/examples/protonect/cmake_modules/FindLibUSB.cmake
index f3e822b..af7a16a 100644
--- a/examples/protonect/cmake_modules/FindLibUSB.cmake
+++ b/examples/protonect/cmake_modules/FindLibUSB.cmake
@@ -8,7 +8,6 @@
 #  LibUSB_LIBRARIES:  the libraries

 IF(PKG_CONFIG_FOUND)
-  SET(ENV{PKG_CONFIG_PATH} "${DEPENDS_DIR}/libusb/lib/pkgconfig")
   PKG_CHECK_MODULES(LibUSB libusb-1.0)
   RETURN()
 ENDIF()

diff --git a/examples/protonect/cmake_modules/FindOpenCL.cmake b/examples/protonect/cmake_modules/FindOpenCL.cmake
deleted file mode 100644
index a062c9e..0000000
--- a/examples/protonect/cmake_modules/FindOpenCL.cmake
+++ /dev/null
@@ -1,75 +0,0 @@
-# - Try to find OpenCL
-# This module tries to find an OpenCL implementation on your system. It supports
-# AMD / ATI, Apple and NVIDIA implementations, but should work, too.
-#
-# To set manually the paths, define these environment variables:
-# OpenCL_INCPATH    - Include path (e.g. OpenCL_INCPATH=/opt/cuda/4.0/cuda/include)
-# OpenCL_LIBPATH    - Library path (e.h. OpenCL_LIBPATH=/usr/lib64/nvidia)
-#
-# Once done this will define
-#  OPENCL_FOUND        - system has OpenCL
-#  OPENCL_INCLUDE_DIRS  - the OpenCL include directory
-#  OPENCL_LIBRARIES    - link these to use OpenCL
-#
-
-FIND_PACKAGE(PackageHandleStandardArgs)
-
-SET (OPENCL_VERSION_STRING "0.1.0")
-SET (OPENCL_VERSION_MAJOR 0)
-SET (OPENCL_VERSION_MINOR 1)
-SET (OPENCL_VERSION_PATCH 0)
-
-IF (APPLE)
-
-	FIND_LIBRARY(OPENCL_LIBRARIES OpenCL DOC "OpenCL lib for OSX")
-	FIND_PATH(OPENCL_INCLUDE_DIRS OpenCL/cl.h DOC "Include for OpenCL on OSX")
-	FIND_PATH(_OPENCL_CPP_INCLUDE_DIRS OpenCL/cl.hpp DOC "Include for OpenCL CPP bindings on OSX")
-
-ELSE (APPLE)
-
-	IF (WIN32)
-		# The AMD SDK currently installs both x86 and x86_64 libraries
-		# This is only a hack to find out architecture
-		IF( ${CMAKE_SIZEOF_VOID_P} EQUAL 8 )
-			FIND_LIBRARY(OPENCL_LIBRARIES OpenCL.lib PATHS "$ENV{ATISTREAMSDKROOT}" "$ENV{AMDAPPSDKROOT}" "$ENV{INTELOCLSDKROOT}" PATH_SUFFIXES "/lib/x86_64" "/lib/x64")
-		ELSE (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
-			FIND_LIBRARY(OPENCL_LIBRARIES OpenCL.lib PATHS "$ENV{ATISTREAMSDKROOT}" "$ENV{AMDAPPSDKROOT}" "$ENV{INTELOCLSDKROOT}" PATH_SUFFIXES "/lib/x86")
-		ENDIF( ${CMAKE_SIZEOF_VOID_P} EQUAL 8 )
-
-		# On Win32 search relative to the library
-		FIND_PATH(OPENCL_INCLUDE_DIRS CL/cl.h PATHS "$ENV{ATISTREAMSDKROOT}" "$ENV{AMDAPPSDKROOT}" "$ENV{INTELOCLSDKROOT}" PATH_SUFFIXES "/include")
-		FIND_PATH(_OPENCL_CPP_INCLUDE_DIRS CL/cl.hpp PATHS "$ENV{ATISTREAMSDKROOT}" "$ENV{AMDAPPSDKROOT}" "$ENV{INTELOCLSDKROOT}" PATH_SUFFIXES "/include")
-
-	ELSE (WIN32)
-
-		# Unix style platforms
-		FIND_LIBRARY(OPENCL_LIBRARIES OpenCL
-			PATHS ENV LD_LIBRARY_PATH ENV OpenCL_LIBPATH
-		)
-
-		GET_FILENAME_COMPONENT(OPENCL_LIB_DIR ${OPENCL_LIBRARIES} PATH)
-		GET_FILENAME_COMPONENT(_OPENCL_INC_CAND ${OPENCL_LIB_DIR}/../../include ABSOLUTE)
-
-		# The AMD SDK currently does not place its headers
-		# in /usr/include, therefore also search relative
-		# to the library
-		FIND_PATH(OPENCL_INCLUDE_DIRS CL/cl.h PATHS ${_OPENCL_INC_CAND} "/usr/local/cuda/include" "/opt/AMDAPP/include" ENV OpenCL_INCPATH)
-		FIND_PATH(_OPENCL_CPP_INCLUDE_DIRS CL/cl.hpp PATHS ${_OPENCL_INC_CAND} "/usr/local/cuda/include" "/opt/AMDAPP/include" ENV OpenCL_INCPATH)
-
-	ENDIF (WIN32)
-
-ENDIF (APPLE)
-
-FIND_PACKAGE_HANDLE_STANDARD_ARGS(OpenCL DEFAULT_MSG OPENCL_LIBRARIES OPENCL_INCLUDE_DIRS)
-
-IF(_OPENCL_CPP_INCLUDE_DIRS)
-	SET( OPENCL_HAS_CPP_BINDINGS TRUE )
-	LIST( APPEND OPENCL_INCLUDE_DIRS ${_OPENCL_CPP_INCLUDE_DIRS} )
-	# This is often the same, so clean up
-	LIST( REMOVE_DUPLICATES OPENCL_INCLUDE_DIRS )
-ENDIF(_OPENCL_CPP_INCLUDE_DIRS)
-
-MARK_AS_ADVANCED(
-  OPENCL_INCLUDE_DIRS
-)
-
