class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/v2.0.0.tar.gz"
  sha256 "606309e8ece04abec062522374b48179c16bddb30dd4c5080b89a4298e8d163b"

  def pour_bottle?
    # Postgres extensions must live in the Postgres prefix, which precludes
    # bottling: https://github.com/Homebrew/homebrew/issues/10247
    # Overcoming this will likely require changes in Postgres itself.
    false
  end

  # work around function name conflict from Postgres
  # https://github.com/pgRouting/pgrouting/issues/274
  patch :DATA

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "build" do
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
