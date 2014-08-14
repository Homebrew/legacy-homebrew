require 'formula'

class Osm2pgsql < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'
  url 'https://github.com/openstreetmap/osm2pgsql/archive/0.84.0.tar.gz'
  sha1 '42145c39596580680f120a07a4f30f97a86a3698'

  bottle do
    cellar :any
    sha1 "dc345c1a9879184ad88a193e9a6ebfcf65f3750a" => :mavericks
    sha1 "b4ecf55fdc125fccb7d994004b46938e8636fbcf" => :mountain_lion
    sha1 "e0dd38b56230cfdad09abda16594fe978352b515" => :lion
  end

  depends_on :postgresql
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "geos"
  depends_on "proj"
  depends_on "protobuf-c" => :optional

  def patches
    DATA
  end

  def install
    args = [
      "--with-proj=#{Formula["proj"].opt_prefix}",
      "--with-zlib=/usr",
      "--with-bzip2=/usr"
    ]
    if build.with? "protobuf-c"
      args << "--with-protobuf-c=#{Formula["protobuf-c"].opt_prefix}"
    end
    system "./autogen.sh"
    system "./configure", *args
    system "make"
    bin.install "osm2pgsql"
    (share+'osm2pgsql').install 'default.style'
  end
end

__END__
--- a/m4/ax_lib_protobuf_c.m4	2012-01-01 00:00:00.000000000 +0000
+++ b/m4/ax_lib_protobuf_c.m4	2012-01-01 00:00:00.000000000 +0000
@@ -207,7 +207,9 @@
       CFLAGS="$CFLAGS $PROTOBUF_C_CFLAGS"
       AX_COMPARE_VERSION([$protobuf_c_wanted_version], [ge], [0.14],
          [AC_CHECK_MEMBER([ProtobufCFieldDescriptor.packed],,
-                          [protobuf_c_version_ok="no"],
+                          [AC_CHECK_MEMBER([ProtobufCFieldDescriptor.flags],,
+                                           [protobuf_c_version_ok="no"],
+                                           [[#include <protobuf-c/protobuf-c.h>]])],
                           [[#include <google/protobuf-c/protobuf-c.h>]
          ])
       ])


--- a/parse-pbf.c	2012-01-01 00:00:00.000000000 +0000
+++ b/parse-pbf.c	2012-01-01 00:00:00.000000000 +0000
@@ -258,7 +258,7 @@
     return 0;
   }
   
-  header_block__free_unpacked (hmsg, &protobuf_c_system_allocator);
+  header_block__free_unpacked (hmsg, NULL);
 
   return 1;
 }
@@ -541,7 +541,7 @@
     if (!processOsmDataRelations(osmdata, group, string_table)) return 0;
   }
 
-  primitive_block__free_unpacked (pmsg, &protobuf_c_system_allocator);
+  primitive_block__free_unpacked (pmsg, NULL);
 
   return 1;
 }
@@ -606,8 +606,8 @@
       }
     }
 
-    blob__free_unpacked (blob_msg, &protobuf_c_system_allocator);
-    block_header__free_unpacked (header_msg, &protobuf_c_system_allocator);
+    blob__free_unpacked (blob_msg, NULL);
+    block_header__free_unpacked (header_msg, NULL);
   } while (!feof(input));
 
   if (!feof(input)) {
