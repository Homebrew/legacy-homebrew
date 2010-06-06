require 'formula'

class Osm2pgsql <Formula
  head 'http://svn.openstreetmap.org/applications/utils/export/osm2pgsql/', :using => :svn
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'

  def patches
    { :p0 => DATA }
  end

  def install
    system "./autogen.sh"
    system "./configure"
    system "make"
    bin.install "osm2pgsql"
  end
end

# simple patch needed on osx to find the malloc include
__END__
Index: middle-pgsql.c
===================================================================
--- middle-pgsql.c	(revision 21558)
+++ middle-pgsql.c	(working copy)
@@ -11,7 +11,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <assert.h>
-#include <malloc.h>
+#include <malloc/malloc.h>
 
 #ifdef HAVE_PTHREAD
 #include <pthread.h>
