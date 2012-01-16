require 'formula'

class Freeling < Formula
  url 'http://devel.cpl.upc.edu/freeling/downloads/15'
  homepage 'http://devel.cpl.upc.edu/freeling'
  md5 '3939a1796a374f16c0fadef10fc487b3'
  version '2.2.2'

  depends_on 'berkeley-db'
  depends_on 'libfries'
  depends_on 'libomlet'
  depends_on 'boost'

  def patches
    # fixes boost include dir
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/analyze -h"
  end
end

__END__
--- FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/common.h	2011-07-28 19:29:34.000000000 +0100
+++ /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/common.h	2012-01-16 15:15:13.000000000 +0000
@@ -20,7 +20,7 @@
 #include <boost/graph/graphviz.hpp>
 #include <boost/graph/adjacency_list.hpp>
 #include <boost/graph/graph_traits.hpp>
-#include <boost/property_map.hpp>
+#include <boost/property_map/property_map.hpp>
 #include <boost/graph/properties.hpp>
 
 // Stuff for generating random numbers
diff -u -r FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/disambGraph.cc /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/disambGraph.cc
--- FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/disambGraph.cc	2011-07-28 19:29:34.000000000 +0100
+++ /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/disambGraph.cc	2012-01-16 15:15:13.000000000 +0000
@@ -27,7 +27,7 @@
 #include <boost/graph/visitors.hpp>
 #include <boost/graph/breadth_first_search.hpp>
 #include <boost/pending/indirect_cmp.hpp>
-#include <boost/pending/integer_range.hpp>
+#include <boost/range/irange.hpp>
 #include <boost/graph/graph_utility.hpp> // for boost::make_list
 
 namespace ukb {
diff -u -r FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/fileElem.cc /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/fileElem.cc
--- FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/fileElem.cc	2011-07-28 19:29:34.000000000 +0100
+++ /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/fileElem.cc	2012-01-16 15:15:13.000000000 +0000
@@ -4,6 +4,8 @@
 
 // Boost filesystem
 #include <boost/version.hpp>
+#define BOOST_FILESYSTEM_VERSION 2
+#define BOOST_FILESYSTEM_DEPRECATED 1
 #include <boost/filesystem/operations.hpp>
 #include <boost/filesystem/path.hpp>
 
diff -u -r FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/kbGraph.cc /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/kbGraph.cc
--- FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/kbGraph.cc	2011-07-28 19:29:34.000000000 +0100
+++ /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/kbGraph.cc	2012-01-16 15:16:40.000000000 +0000
@@ -30,7 +30,7 @@
 #include <boost/graph/visitors.hpp>
 #include <boost/graph/breadth_first_search.hpp>
 #include <boost/pending/indirect_cmp.hpp>
-#include <boost/pending/integer_range.hpp>
+#include <boost/range/irange.hpp>
 #include <boost/graph/graph_utility.hpp> // for boost::make_list
 
 // dijkstra
diff -u -r FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/kbGraph.h /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/kbGraph.h
--- FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/kbGraph.h	2011-07-28 19:29:34.000000000 +0100
+++ /private/tmp/homebrew-freeling-2.2.2-bMus/FreeLing-2.2.2/src/libmorfo/disambiguator/ukb/kbGraph.h	2012-01-16 15:15:13.000000000 +0000
@@ -20,7 +20,7 @@
 
 #include <boost/graph/adjacency_list.hpp>
 #include <boost/graph/graph_traits.hpp>
-#include <boost/property_map.hpp>
+#include <boost/property_map/property_map.hpp>
 #include <boost/graph/properties.hpp>
 
 using boost::adjacency_list;
