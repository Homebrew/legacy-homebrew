require 'formula'

class Libftdi <Formula
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.17.tar.gz"
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  md5 '810c69cfaa078b49795c224ef9b6b851'

  depends_on 'cmake'
  depends_on 'libusb-compat'

  def patches
    DATA
  end

  def install
    mkdir 'libftdi-build'
    Dir.chdir 'libftdi-build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make"
      system "make install"
    end
  end
end

__END__
--- a/CMakeLists.txt	2009-12-24 12:09:27.000000000 +0100
+++ b/CMakeLists.txt	2009-12-24 12:11:07.000000000 +0100
@@ -38,14 +38,8 @@
 set(CPACK_COMPONENT_STATICLIBS_GROUP "Development")
 set(CPACK_COMPONENT_HEADERS_GROUP    "Development")
 
-# Create suffix to eventually install in lib64
-IF(CMAKE_SIZEOF_VOID_P EQUAL 4)
-    SET(LIB_SUFFIX "")
-    SET(PACK_ARCH "")
-  ELSE(CMAKE_SIZEOF_VOID_P EQUAL 4)
-    SET(LIB_SUFFIX 64)
-    SET(PACK_ARCH .x86_64)
-endif(CMAKE_SIZEOF_VOID_P EQUAL 4)
+SET(LIB_SUFFIX "")
+SET(PACK_ARCH "")
 
 # Package information
 set(CPACK_PACKAGE_VERSION              ${VERSION_STRING})
@@ -85,8 +79,6 @@
 
 add_subdirectory(src)
 add_subdirectory(ftdipp)
-add_subdirectory(bindings)
-add_subdirectory(examples)
 add_subdirectory(packages)
