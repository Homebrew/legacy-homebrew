require 'formula'

class Mdbtools < Formula
  homepage 'https://github.com/brianb/mdbtools/'
  url "https://github.com/brianb/mdbtools/tarball/0.7_rc1"
  sha1 '584d001105d1744424db9b781a83c67ae2ecac04'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gawk' => :optional # To generate docs

  if MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Use glibtoolize, remove unknown linker flags
  def patches
    DATA
  end

  def install
    system "NOCONFIGURE='yes' ./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-glibtest"
    system "make install"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index 0d07ee5..1b85a3b 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -19,10 +19,10 @@ DIE=0
 }
 
 (grep "^A[CM]_PROG_LIBTOOL" $srcdir/configure.in >/dev/null) && {
-  (libtool --version) < /dev/null > /dev/null 2>&1 || {
+  (glibtool --version) < /dev/null > /dev/null 2>&1 || {
     echo
-    echo "**Error**: You must have \`libtool' installed."
-    echo "Get ftp://ftp.gnu.org/pub/gnu/libtool-1.2d.tar.gz"
+    echo "**Error**: You must have \`glibtool' installed."
+    echo "Get ftp://ftp.gnu.org/pub/gnu/glibtool-1.2d.tar.gz"
     echo "(or a newer version if it is available)"
     DIE=1
   }
@@ -128,8 +128,8 @@ do
       echo "Running aclocal $aclocalinclude ..."
       aclocal $aclocalinclude
       if grep "^A[CM]_PROG_LIBTOOL" configure.in >/dev/null; then
-	echo "Running libtoolize..."
-	libtoolize --force --copy
+	echo "Running glibtoolize..."
+	glibtoolize --force --copy
       fi
       if grep "^A[CM]_CONFIG_HEADER" configure.in >/dev/null; then
 	echo "Running autoheader..."
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
