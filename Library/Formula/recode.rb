require 'formula'

class Recode < Formula
  homepage 'http://recode.progiciels-bpi.ca/index.html'
  url 'https://github.com/pinard/Recode/tarball/v3.6'
  md5 'f82e9a6ede9119268c13493c9add2809'

  depends_on "gettext"
  depends_on :libtool

  # Patches from MacPorts
  # No reason for patch given, no link to patches given. Someone shoot that guy :P
  def patches
    { :p0 => DATA }
  end

  def install
    ENV.append 'LDFLAGS', '-liconv'

    if MacOS.xcode_version >= "4.3"
      d = "#{HOMEBREW_PREFIX}/share/libtool/config"
      cp ["#{d}/config.guess", "#{d}/config.sub"], "."
    elsif MacOS.leopard?
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config.*"], "."
    else
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config/config.*"], "."
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--without-included-gettext",
                          "--infodir=#{info}",
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
