require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Pgrouting < Formula
  homepage 'http://www.pgrouting.org'
  url 'http://download.osgeo.org/pgrouting/source/pgrouting-1.05.tar.gz'
  md5 'bd7c106e3db3c38f7081f1ee9b0e12ae'

  depends_on 'boost'
  depends_on 'postgresql'
  depends_on 'postgis' #=> :build

  def patches
    # fixes something small
    DATA
  end

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

    # system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # "--prefix=#{prefix}"
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test pgrouting`.
    system "false"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1d6612c..7a7ef8d 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -64,7 +64,7 @@ OPTION(WITH_DD "Build Driving distance library" OFF)
 
 IF(UNIX)
   SET(LIBRARY_INSTALL_PATH ${LIB_DIR})
-  SET(SQL_INSTALL_PATH /usr/share/postlbs)
+  SET(SQL_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/share/postlbs)
   MESSAGE("Installation directory for libraries is set to ${LIBRARY_INSTALL_PATH} and for SQL files is set to ${SQL_INSTALL_PATH}")
 ELSE(UNIX)
   SET(LIBRARY_INSTALL_PATH ${PGROUTING_BINARY_DIR}/lib)
diff --git a/cmake/FindPostgreSQL.cmake b/cmake/FindPostgreSQL.cmake
index 8b1b4c8..266cf3a 100644
--- a/cmake/FindPostgreSQL.cmake
+++ b/cmake/FindPostgreSQL.cmake
@@ -4,6 +4,7 @@
 #  POSTGRESQL_INCLUDE_DIR, where to find POSTGRESQL.h
 #  POSTGRESQL_LIBRARIES, the libraries needed to use POSTGRESQL.
 #  POSTGRESQL_FOUND, If false, do not try to use PostgreSQL.
+#  POSTGRESQL_EXECUTABLE
 #
 # Copyright (c) 2006, Jaroslaw Staniek, <js@iidea.pl>
 #
@@ -12,13 +13,16 @@
 
 # Add the postgresql and mysql include paths here
 
-if(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES)
+if(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES AND POSTGRESQL_EXECUTABLE)
    set(POSTGRESQL_FOUND TRUE)
-
-else(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES)
+else(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES AND POSTGRESQL_EXECUTABLE)
 
 #  find_path(POSTGRESQL_INCLUDE_DIR libpq-fe.h
 
+ FIND_PROGRAM(POSTGRESQL_EXECUTABLE postgres)
+ MESSAGE(STATUS "POSTGRESQL_EXECUTABLE is " ${POSTGRESQL_EXECUTABLE})
+
+
  FIND_PATH(POSTGRESQL_INCLUDE_DIR postgres.h
       /usr/include/server
       /usr/include/pgsql/server
@@ -54,4 +58,4 @@ else(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES)
 
   mark_as_advanced(POSTGRESQL_INCLUDE_DIR POSTGRESQL_LIBRARIES)
 
-endif(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES)
+endif(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARIES AND POSTGRESQL_EXECUTABLE)
diff --git a/core/src/CMakeLists.txt b/core/src/CMakeLists.txt
index ba070df..12e4fc5 100644
--- a/core/src/CMakeLists.txt
+++ b/core/src/CMakeLists.txt
@@ -1,6 +1,13 @@
 
 SET(LIBRARY_OUTPUT_PATH ../../lib/)
-ADD_LIBRARY(routing SHARED dijkstra.c astar.c shooting_star.c boost_wrapper.cpp astar_boost_wrapper.cpp shooting_star_boost_wrapper.cpp)
+IF(APPLE)
+    SET(LIBRARY_MODE_TARGET "MODULE")
+ELSE(APPLE)
+    SET(LIBRARY_MODE_TARGET "SHARED")
+ENDIF(APPLE)
+ADD_LIBRARY(routing ${LIBRARY_MODE_TARGET} dijkstra.c astar.c shooting_star.c boost_wrapper.cpp astar_boost_wrapper.cpp shooting_star_boost_wrapper.cpp)
 INSTALL(TARGETS routing DESTINATION ${LIBRARY_INSTALL_PATH})
-
+IF(APPLE)
+    SET_TARGET_PROPERTIES(routing PROPERTIES LINK_FLAGS "-bundle_loader ${POSTGRESQL_EXECUTABLE} -bundle")
+ENDIF(APPLE)
 
diff --git a/core/src/edge_visitors.hpp b/core/src/edge_visitors.hpp
index 45e37ee..fc44252 100644
--- a/core/src/edge_visitors.hpp
+++ b/core/src/edge_visitors.hpp
@@ -3,10 +3,10 @@
 
 #include <iosfwd>
 #include <boost/config.hpp>
-#include <boost/property_map.hpp>
+#include <boost/property_map/property_map.hpp>
 #include <boost/graph/graph_traits.hpp>
 #include <boost/limits.hpp>
-#include <boost/graph/detail/is_same.hpp>
+#include <boost/type_traits/is_same.hpp>
 
 namespace boost 
 {
diff --git a/core/src/shooting_star_boost_wrapper.cpp b/core/src/shooting_star_boost_wrapper.cpp
index 55c8e38..bf28713 100644
--- a/core/src/shooting_star_boost_wrapper.cpp
+++ b/core/src/shooting_star_boost_wrapper.cpp
@@ -23,7 +23,7 @@
 
 #include <boost/graph/graph_traits.hpp>
 #include <boost/graph/adjacency_list.hpp>
-#include <boost/vector_property_map.hpp>
+#include <boost/property_map/vector_property_map.hpp>
 #include <shooting_star_search.hpp>
 
 #include "shooting_star.h"
diff --git a/core/src/shooting_star_relax.hpp b/core/src/shooting_star_relax.hpp
index 8e65be6..95b222e 100644
--- a/core/src/shooting_star_relax.hpp
+++ b/core/src/shooting_star_relax.hpp
@@ -15,7 +15,7 @@
 #include <functional>
 #include <boost/limits.hpp> // for numeric limits
 #include <boost/graph/graph_traits.hpp>
-#include <boost/property_map.hpp>
+#include <boost/property_map/property_map.hpp>
 
 #include <postgres.h>
 
