require 'formula'

class Osm2pgrouting < Formula
  homepage 'http://pgrouting.org/docs/tools/osm2pgrouting.html'
  url 'https://github.com/pgRouting/osm2pgrouting/archive/v2.0.0.tar.gz'
  sha1 '2d100ac9914919993a7c341e2395b8bafdfe3759'
  head 'https://github.com/pgRouting/osm2pgrouting.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on :postgresql

  def patches
    # Fixes the default hard-coded /usr/share which the program would be installed in.
    # Instead we supply relative paths, and run cmake with flag -DCMAKE_INSTALL_PREFIX=#{prefix} so that
    # we get a proper absolute path. This flag is part of the std_cmake_args, so it's not specified explicitly.
    DATA
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 6b0402b..50e02c9 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -2,7 +2,7 @@ PROJECT(osm2pgrouting)
 CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
 
 set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
-set (SHARE_DIR "/usr/share/osm2pgrouting")
+set (SHARE_DIR ".")
 
 FIND_PACKAGE(PostgreSQL REQUIRED)
 FIND_PACKAGE(EXPAT REQUIRED)
@@ -19,7 +19,7 @@ ADD_EXECUTABLE(osm2pgrouting ${SRC})
 TARGET_LINK_LIBRARIES(osm2pgrouting ${PostgreSQL_LIBRARIES} ${EXPAT_LIBRARIES})
 
 INSTALL(TARGETS osm2pgrouting
-  RUNTIME DESTINATION "/usr/share/bin"
+  RUNTIME DESTINATION "bin"
 )
 
 INSTALL(FILES

