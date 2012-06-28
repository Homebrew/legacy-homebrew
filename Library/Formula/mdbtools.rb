require 'formula'

class Mdbtools < Formula
  homepage 'https://github.com/brianb/mdbtools/'
  url "https://github.com/brianb/mdbtools/tarball/0.7"
  sha1 '62fe0703fd8691e4536e1012317406bdb72594cf'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'readline'

  if MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # remove unknown linker flags
  def patches
    DATA
  end

  def install
    system "NOCONFIGURE='yes' ./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure.in b/configure.in
index 797ad72..bec756d 100644
--- a/configure.in
+++ b/configure.in
@@ -61,7 +61,7 @@ AM_CONDITIONAL(SQL, test x$sql = xtrue)
 AC_SUBST(SQL)
 AC_SUBST(LFLAGS)
 
-LDFLAGS="$LDFLAGS -Wl,--as-needed"
+LDFLAGS="$LDFLAGS -Wl,"
 
 dnl check for iODBC
 
diff --git a/src/libmdb/Makefile.am b/src/libmdb/Makefile.am
index 58ef696..008cd41 100644
--- a/src/libmdb/Makefile.am
+++ b/src/libmdb/Makefile.am
@@ -1,5 +1,5 @@
 lib_LTLIBRARIES	=	libmdb.la
 libmdb_la_SOURCES=	catalog.c mem.c file.c table.c data.c dump.c backend.c money.c sargs.c index.c like.c write.c stats.c map.c props.c worktable.c options.c iconv.c
-libmdb_la_LDFLAGS = -version-info 2:0:0 -Wl,--version-script=$(srcdir)/libmdb.map
+libmdb_la_LDFLAGS = -version-info 2:0:0 -Wl
 AM_CPPFLAGS	=	-I$(top_srcdir)/include $(GLIB_CFLAGS)
 LIBS = $(GLIB_LIBS) @LIBS@
diff --git a/src/sql/Makefile.am b/src/sql/Makefile.am
index e79522f..a14a6c6 100644
--- a/src/sql/Makefile.am
+++ b/src/sql/Makefile.am
@@ -1,6 +1,6 @@
 lib_LTLIBRARIES	=	libmdbsql.la
 libmdbsql_la_SOURCES=	mdbsql.c parser.y lexer.l 
-libmdbsql_la_LDFLAGS = -version-info 2:0:0 -Wl,--version-script=$(srcdir)/libmdbsql.map
+libmdbsql_la_LDFLAGS = -version-info 2:0:0 -Wl
 DISTCLEANFILES = parser.c parser.h lexer.c
 AM_CPPFLAGS	=	-I$(top_srcdir)/include $(GLIB_CFLAGS)
 LIBS	=	$(GLIB_LIBS)
