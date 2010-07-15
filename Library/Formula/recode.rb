require 'formula'

class Recode <Formula
  url 'http://ftp.gnu.org/pub/gnu/recode/recode-3.6.tar.gz'
  homepage 'http://www.gnu.org/software/recode/'
  md5 'be3f40ad2e93dae5cd5f628264bf1877'

  depends_on "gettext"

  def patches
    # Patches from MacPorts
    { :p0 => DATA }
  end

  def install
    cp "/usr/share/libtool/config/config.guess", "."
    cp "/usr/share/libtool/config/config.sub", "."
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--without-included-gettext",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
--- lib/Makefile.in.orig	2007-10-20 01:45:40.000000000 +0200
+++ lib/Makefile.in	2007-10-20 01:46:19.000000000 +0200
@@ -107,8 +107,8 @@
 AUTOMAKE_OPTIONS = gnits
 
 noinst_LIBRARIES = libreco.a
-noinst_HEADERS = error.h getopt.h gettext.h pathmax.h xstring.h
-libreco_a_SOURCES = error.c getopt.c getopt1.c xstrdup.c
+noinst_HEADERS = error.h gettext.h pathmax.h xstring.h
+libreco_a_SOURCES = error.c xstrdup.c
 
 EXTRA_DIST = alloca.c gettext.c malloc.c realloc.c strtol.c strtoul.c
 
@@ -128,7 +128,7 @@
 LDFLAGS = @LDFLAGS@
 LIBS = @LIBS@
 libreco_a_DEPENDENCIES =  @ALLOCA@ @LIBOBJS@
-libreco_a_OBJECTS =  error.o getopt.o getopt1.o xstrdup.o
+libreco_a_OBJECTS =  error.o xstrdup.o
 AR = ar
 CFLAGS = @CFLAGS@
 COMPILE = $(CC) $(DEFS) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) $(AM_CFLAGS) $(CFLAGS)
--- src/libiconv.c.orig	2000-07-01 11:13:25.000000000 -0600
+++ src/libiconv.c	2008-10-21 01:24:40.000000000 -0600
@@ -195,12 +195,17 @@
 	 memcpy() doesn't do here, because the regions might overlap.
 	 memmove() isn't worth it, because we rarely have to move more
 	 than 12 bytes.  */
-      if (input > input_buffer && input_left > 0)
+      cursor = input_buffer;
+      if (input_left > 0)
 	{
-	  cursor = input_buffer;
-	  do
-	    *cursor++ = *input++;
-	  while (--input_left > 0);
+	  if (input > input_buffer)
+	    {
+	      do
+		*cursor++ = *input++;
+	      while (--input_left > 0);
+	    }
+	  else
+	    cursor += input_left;
 	}
     }
