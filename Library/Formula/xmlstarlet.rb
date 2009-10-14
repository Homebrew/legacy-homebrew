require 'formula'

class Xmlstarlet <Formula
  url 'http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.0.1/xmlstarlet-1.0.1.tar.gz'
  homepage 'http://xmlstar.sourceforge.net/'
  md5 '8deb71834bcdfb4443c258a1f0042fce'

  def patches
    DATA
  end

  def install
    ENV.x11
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

__END__
diff -u a/configure b/configure
--- a/configure	2009-10-14 14:31:08.000000000 -0700
+++ b/configure	2009-10-14 14:30:14.000000000 -0700
@@ -2096,6 +2096,11 @@
 WIN32_EXTRA_LIBADD=
 WIN32_EXTRA_LDFLAGS=
 
+if test "x$LIBXML_LIBS" = "x"
+then
+	LIBXML_LIBS="${LIBXML_PREFIX}/lib/libxml2.a -lz -lm -lpthread -ldl"
+fi
+
 case "${host}" in
   *sun* )
       LIBXML_LIBS="${LIBXML_LIBS} -lsocket -lnsl"
@@ -2109,7 +2114,7 @@
           LIBXML_LIBS="${LIBXML_LIBS} -liconv"
       fi
       ;;
-  *mac* )
+  *mac* | *darwin* )
       if test "x$LIBICONV_LIBS" = "x"
       then
           LIBXML_LIBS="${LIBXML_LIBS} ${LIBICONV_LIBS} -liconv"
@@ -2157,11 +2162,6 @@
 	LIBXML_CFLAGS="-I${LIBXML_PREFIX}/include/libxml2"
 fi
 
-if test "x$LIBXML_LIBS" = "x"
-then
-	LIBXML_LIBS="${LIBXML_PREFIX}/lib/libxml2.a -lz -lm -lpthread -ldl"
-fi
-
 if test "x$LIBXSLT_CFLAGS" = "x"
 then
 	LIBXSLT_CFLAGS="-I${LIBXSLT_PREFIX}/include/libxslt -I${LIBXSLT_PREFIX}/include/libexslt"
