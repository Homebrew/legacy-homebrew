require 'formula'

class Yajl <Formula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://github.com/lloyd/yajl/tarball/1.0.11'
  md5 '5b60f4d59b3b1fb42d7808d08460fb12'

  def patches
    # All YAJL releases so far have an rpath bug, though its fixed in upstream git:
    # https://github.com/lloyd/yajl/commit/a31c4d0f9ad90b4b58508702fd877bb35039067e
    DATA
  end

  # Configure uses cmake, even though it looks like we're
  # just using autotools below.
  depends_on 'cmake' => :build

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (include + 'yajl').install Dir['src/api/*.h']
  end
end


__END__
diff -U 3 -r lloyd-yajl-f4baae0-orig/CMakeLists.txt lloyd-yajl-f4baae0/CMakeLists.txt
--- lloyd-yajl-f4baae0-orig/CMakeLists.txt	2010-07-22 08:12:15.000000000 +1000
+++ lloyd-yajl-f4baae0/CMakeLists.txt	2011-02-18 19:04:46.000000000 +1100
@@ -38,10 +38,6 @@
 
 SET (YAJL_DIST_NAME "yajl-${YAJL_MAJOR}.${YAJL_MINOR}.${YAJL_MICRO}")
 
-# RPATH handling -- given we statically link, we'll turn off
-# unnec. rpath embedding
-SET(CMAKE_SKIP_RPATH  TRUE)
-
 IF (NOT CMAKE_BUILD_TYPE)
   SET(CMAKE_BUILD_TYPE "Release")
 ENDIF (NOT CMAKE_BUILD_TYPE)
diff -U 3 -r lloyd-yajl-f4baae0-orig/src/CMakeLists.txt lloyd-yajl-f4baae0/src/CMakeLists.txt
--- lloyd-yajl-f4baae0-orig/src/CMakeLists.txt	2010-07-22 08:12:15.000000000 +1000
+++ lloyd-yajl-f4baae0/src/CMakeLists.txt	2011-02-18 19:06:02.000000000 +1100
@@ -60,6 +60,13 @@
                       SOVERSION ${YAJL_MAJOR}
                       VERSION ${YAJL_MAJOR}.${YAJL_MINOR}.${YAJL_MICRO})
 
+#### ensure a .dylib has correct absolute installation paths upon installation
+IF(APPLE)
+  MESSAGE("INSTALL_NAME_DIR: ${CMAKE_INSTALL_PREFIX}/lib")
+  SET_TARGET_PROPERTIES(yajl PROPERTIES
+                        INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib")
+ENDIF(APPLE)
+
 #### build up an sdk as a post build step
 
 # create some directories
