require 'formula'

class Aggregate <Formula
  url 'ftp://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz'
  md5 '6fcc515388bf2c5b0c8f9f733bfee7e1'

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
--- aggregate-1.6/Makefile.in.orig	2010-12-03 09:59:22.000000000 -0800
+++ aggregate-1.6/Makefile.in	2010-12-03 10:03:26.000000000 -0800
@@ -25,7 +25,7 @@
 INSTALL = @INSTALL@
 DEFS = @DEFS@
 LIBS = @LIBS@
-CFLAGS = -O
+CFLAGS = @CFLAGS@
 LDFLAGS = -s
 prefix = @prefix@
 
@@ -41,10 +41,12 @@
 	rm -f *.o
 
 install: $(PROGS)
+	$(INSTALL) -d -m 0755 $(prefix)/bin/
+	$(INSTALL) -d -m 0755 $(prefix)/share/man/man1/
 	$(INSTALL) -m 0755 aggregate $(prefix)/bin/
-	$(INSTALL) -m 0644 aggregate.1 $(prefix)/man/man1/
+	$(INSTALL) -m 0644 aggregate.1 $(prefix)/share/man/man1/
 	$(INSTALL) -m 0755 aggregate-ios $(prefix)/bin/
-	$(INSTALL) -m 0644 aggregate-ios.1 $(prefix)/man/man1/
+	$(INSTALL) -m 0644 aggregate-ios.1 $(prefix)/share/man/man1/
 
 .c.o:
 	$(CC) -c $(CPPFLAGS) $(DEFS) $(CFLAGS) $<
