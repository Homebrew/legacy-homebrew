require 'formula'

class Udns < Formula
  homepage 'http://www.corpit.ru/mjt/udns.html'
  url 'http://www.corpit.ru/mjt/udns/udns-0.2.tar.gz'
  sha1 '416da8c95283eae45f6d2e6fb055c4ef765a3f02'

  # Build target for dylib. See:
  # http://www.corpit.ru/pipermail/udns/2011q3/000154.html
  patch :DATA

  def install
    system "./configure"
    system "make"
    system "make dylib"

    bin.install "dnsget", "rblcheck"
    doc.install "NOTES", "TODO", "ex-rdns.c"
    include.install "udns.h"
    lib.install "libudns.a", "libudns.0.dylib", "libudns.dylib"
    man1.install "dnsget.1", "rblcheck.1"
    man3.install "udns.3"
  end
end

__END__
--- udns-0.1.orig/Makefile.in	2010-12-27 09:35:02.000000000 -0800
+++ udns-0.1/Makefile.in	2011-05-03 15:09:46.000000000 -0700
@@ -42,7 +42,10 @@
 SOLIBV = lib$(NAME).so.$(SOVER)
 SOLIBFL= -L. -l$(NAME)_s
 
-LIBS   = $(LIB) $(SOLIBV)
+DYLIB  = lib$(NAME).dylib
+DYLIBV = lib$(NAME).$(SOVER).dylib
+
+LIBS   = $(LIB) $(SOLIBV) $(DYLIB)
 
 UTILS   = $(USRCS:.c=)
 UOBJS   = $(USRCS:.c=.o)
@@ -68,6 +71,14 @@
 .c.o:
 	$(CC) $(CFLAGS) $(CDEFS) -c $<
 
+dylib: $(DYLIB)
+
+$(DYLIBV): $(SOBJS)
+	$(CC) -dynamiclib $(SOBJS) -o $(DYLIBV)
+$(DYLIB): $(DYLIBV)
+	rm -f $@
+	ln -s $(DYLIBV) $@
+
 shared: $(SOLIBV) $(SOUTILS)
 sharedlib: $(SOLIBV)
 
