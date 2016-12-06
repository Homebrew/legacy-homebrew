require 'formula'

class Wmii <Formula
  url 'http://dl.suckless.org/wmii/wmii-3.6.tar.gz'
  homepage 'http://wmii.suckless.org/'
  md5 '9d17a09871fada998b4d989d9318bbf5'

  @@codePatch = "diff -ruN wmii-3.6/cmd/util.c wmii-3.6-messedwith-1/cmd/util.c
--- wmii-3.6/cmd/util.c	2007-11-16 05:59:15.000000000 -0800
+++ wmii-3.6-messedwith-1/cmd/util.c	2011-01-09 15:08:44.000000000 -0800
@@ -61,12 +61,12 @@
 		size /= 10;
 	} while(size > 0);

-	strlcat(buf, argv0, sizeof(buf));
-	strlcat(buf, couldnot, sizeof(buf));
-	strlcat(buf, name, sizeof(buf));
-	strlcat(buf, paren, sizeof(buf));
-	strlcat(buf, sizestr+i, sizeof(buf));
-	strlcat(buf, bytes, sizeof(buf));
+	wmii_strlcat(buf, argv0, sizeof(buf));
+	wmii_strlcat(buf, couldnot, sizeof(buf));
+	wmii_strlcat(buf, name, sizeof(buf));
+	wmii_strlcat(buf, paren, sizeof(buf));
+	wmii_strlcat(buf, sizestr+i, sizeof(buf));
+	wmii_strlcat(buf, bytes, sizeof(buf));
 	write(2, buf, strlen(buf));

 	exit(1);
@@ -151,7 +151,7 @@
 }

 uint
-strlcat(char *dst, const char *src, uint size) {
+wmii_strlcat(char *dst, const char *src, uint size) {
 	const char *s;
 	char *d;
 	int n, len;
diff -ruN wmii-3.6/include/util.h wmii-3.6-messedwith-1/include/util.h
--- wmii-3.6/include/util.h	2007-11-16 05:59:15.000000000 -0800
+++ wmii-3.6-messedwith-1/include/util.h	2011-01-09 15:08:09.000000000 -0800
@@ -23,7 +23,6 @@
 typedef unsigned long long	uvlong;
 typedef long long		vlong;

-#define strlcat wmii_strlcat
 /* util.c */
 uint tokenize(char *res[], uint reslen, char *str, char delim);
 char *estrdup(const char *str);
@@ -35,7 +34,7 @@
 int min(int a, int b);
 char *str_nil(char *s);
 int utflcpy(char *to, const char *from, int l);
-uint strlcat(char *dst, const char *src, unsigned int siz);
+uint wmii_strlcat(char *dst, const char *src, unsigned int siz);

 char *argv0;
 void *__p;
"
  @@configPatch = "--- wmii-3.6/config.mk	2007-11-16 05:59:15.000000000 -0800
+++ config.mk	2011-01-09 15:04:37.000000000 -0800
@@ -16,7 +16,7 @@
 include ${ROOT}/mk/gcc.mk
 CFLAGS += -g -O0 -DIXPlint
 LDFLAGS += -g ${LIBS}
-STATIC = -static
+STATIC =# -static
 MKDEP = cpp -M

 # Compiler
@@ -29,9 +29,9 @@
 AWKPATH = $$(which awk)
 P9PATHS = ${PLAN9}:\"'$${HOME}/plan9'\":/usr/local/plan9:/usr/local/9:/opt/plan9:/opt/9:/usr/plan9:/usr/9

-INCX11 = -I/usr/X11R6/include
+INCX11 = -I/usr/X11R6/include -I/usr/include
 LIBX11 = -L/usr/X11R6/lib -lX11
-LIBICONV = # Leave blank if your libc includes iconv (glibc does)
+LIBICONV = -liconv -L/usr/local/lib
 LIBIXP = ${ROOT}/libixp/libixp.a
 LIBIXP = ${LIBDIR}/libixp.a
"

  depends_on 'libixp'

  def install
    handle = File.new("codepatch.patch", "w")
    handle.write(@@codePatch)
    handle.close

    handle = File.new("configpatch.patch", "w")
    handle.write(@@configPatch)
    handle.close

    system "patch -p1 < codepatch.patch"
    system "patch -p1 < configpatch.patch"
    system "make"
    system "make install"
  end
end
