require 'formula'

class Pgrouting < Formula
  homepage 'http://www.pgrouting.org'
  url "https://github.com/pgRouting/pgrouting/archive/v2.0.0.tar.gz"
  sha1 "cd2f60dc49df7bc8c789c8e73ecb9759194fab96"

  bottle do
    cellar :any
    sha1 "5630b70733c8106498e99cd86a7dfb0efad61d99" => :yosemite
    sha1 "e534968cb994d3d3cf0315eec1277d5339cc4984" => :mavericks
    sha1 "a0f566240642fb80b4b906f58bab8be265521099" => :mountain_lion
  end

  # work around function name conflict from Postgres
  # https://github.com/pgRouting/pgrouting/issues/274
  patch :DATA

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'cgal'
  depends_on 'postgis'
  depends_on 'postgresql'

  def install
    mkdir 'build' do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
__END__
diff --git a/src/astar/src/astar.h b/src/astar/src/astar.h
index d5872bb..34a0621 100644
--- a/src/astar/src/astar.h
+++ b/src/astar/src/astar.h
@@ -21,6 +21,7 @@

 #define _ASTAR_H

+#include <unistd.h>
 #include "postgres.h"
 #include "dijkstra.h"

diff --git a/src/dijkstra/src/dijkstra.h b/src/dijkstra/src/dijkstra.h
index ca5bea4..09ac6f1 100644
--- a/src/dijkstra/src/dijkstra.h
+++ b/src/dijkstra/src/dijkstra.h
@@ -22,6 +22,7 @@
 #ifndef _DIJKSTRA_H
 #define _DIJKSTRA_H

+#include <unistd.h>
 #include "postgres.h"

 typedef struct edge
diff --git a/src/driving_distance/src/drivedist.h b/src/driving_distance/src/drivedist.h
index e85bdd7..ce20b8b 100644
--- a/src/driving_distance/src/drivedist.h
+++ b/src/driving_distance/src/drivedist.h
@@ -22,6 +22,7 @@
 #ifndef _DRIVEDIST_H
 #define _DRIVEDIST_H

+#include <unistd.h>
 #include "postgres.h"
 #include "dijkstra.h"
