require 'formula'

class Cconv < Formula
  homepage 'http://code.google.com/p/cconv/'
  url 'https://cconv.googlecode.com/files/cconv-0.6.2.tar.gz'
  sha1 '9775f91fd5600d176552a88625aaa1f64ece09c1'

  # fix link with iconv: http://code.google.com/p/cconv/issues/detail?id=18
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    rm include/"unicode.h"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 7cdb9aa..93afc5b 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -207,7 +207,7 @@ AC_CFLAGS = -Wall @ICONV_INCLUDES@ @OS_TYPE@
 ACLOCAL_AMFLAGS = -I m4
 cconv_SOURCES = cconv.c main.c unicode.c
 cconv_CFLAGS = ${AC_CFLAGS}
-cconv_LDFLAGS = @ICONV_LIBS@
+cconv_LDFLAGS = @ICONV_LIBS@ -liconv
 lib_LTLIBRARIES = libcconv.la
 libcconv_la_SOURCES = cconv.c unicode.c
 libcconv_la_CFLAGS = -Wall @ICONV_INCLUDES@ @OS_TYPE@
