require 'formula'

class A2ps <Formula
  url 'http://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz'
  homepage 'http://www.gnu.org/software/a2ps/'
  md5 '781ac3d9b213fa3e1ed0d79f986dc8c7'

  def patches
      DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
# 1) xstrrpl.c is wrongly declaring stpcpy as an external function and the
# compiler is complaining about the function having only one argument, see 
# https://svn.macports.org/ticket/20867
#
# 2) Fixes build failure on Tiger by reordering args. See
# http://trac.macports.org/ticket/18255 
--- a/lib/xstrrpl.c
+++ b/lib/xstrrpl.c
@@ -22,8 +22,6 @@
 #include <assert.h>
 #include "xstrrpl.h"

-extern char * stpcpy();
-
 /* Perform subsitutions in string.  Result is malloc'd
    E.g., result = xstrrrpl ("1234", subst) gives result = "112333"
    where subst = { {"1", "11"}, {"3", "333"}, { "4", ""}}
--- a/contrib/sample/Makefile.in
+++ b/contrib/sample/Makefile.in
@@ -298,7 +298,7 @@
 AUTOMAKE_OPTIONS = $(top_builddir)/lib/ansi2knr
 sample_SOURCES = main.c
 INCLUDES = -I. -I.. -I$(top_builddir) -I$(top_srcdir)/intl -I$(top_srcdir)/lib
-sample_LDADD = $(top_builddir)/lib/liba2ps.la @LIBINTL@ -lm
+sample_LDADD = -lm $(top_builddir)/lib/liba2ps.la @LIBINTL@
 all: all-am

 .SUFFIXES:

