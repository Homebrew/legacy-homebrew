require 'brewkit'

class Weechat <Formula
  @url='http://www.weechat.org/files/src/weechat-0.3.0.tar.bz2'
  @homepage='http://www.weechat.org'
  @md5='c31cfc229e964ff9257cc9c7f9e6c9bc'

  depends_on 'cmake'
  depends_on 'gnutls'

  def patches
    DATA
  end

  def install
    #FIXME: Compiling perl module doesn't work
    #NOTE: -DPREFIX has to be specified because weechat devs enjoy being non-standard
    system "cmake", "-DPREFIX=#{prefix}", 
                    "-DDISABLE_PERL=ON",
                    std_cmake_parameters, "."
    system "make install"
  end
end

__END__
diff --git a/cmake/FindIconv.cmake b/cmake/FindIconv.cmake
index a7b2d24..371d630 100644
--- a/cmake/FindIconv.cmake
+++ b/cmake/FindIconv.cmake
@@ -43,10 +43,7 @@ FIND_LIBRARY(ICONV_LIBRARY
 IF(ICONV_INCLUDE_PATH)
   IF(ICONV_LIBRARY)
     STRING(REGEX REPLACE "/[^/]*$" "" ICONV_LIB_PATH "${ICONV_LIBRARY}")
-    CHECK_LIBRARY_EXISTS(iconv libiconv_open ${ICONV_LIB_PATH} ICONV_FOUND)
-    IF(NOT ICONV_FOUND)
-      CHECK_LIBRARY_EXISTS(iconv iconv_open ${ICONV_LIB_PATH} ICONV_FOUND)
-    ENDIF(NOT ICONV_FOUND)
+    CHECK_LIBRARY_EXISTS(iconv iconv_open ${ICONV_LIB_PATH} ICONV_FOUND)
   ELSE(ICONV_LIBRARY)
     CHECK_FUNCTION_EXISTS(iconv_open ICONV_FOUND)
   ENDIF(ICONV_LIBRARY)
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 50d2f01..f812c74 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -92,6 +92,7 @@ ENDIF(NOT DISABLE_GNUTLS)
 FIND_PACKAGE(Iconv)
 IF(ICONV_FOUND)
   ADD_DEFINITIONS( -DHAVE_ICONV )
+  LIST(APPEND EXTRA_LIBS iconv)
 ENDIF(ICONV_FOUND)
 
 FIND_LIBRARY(DL_LIBRARY

