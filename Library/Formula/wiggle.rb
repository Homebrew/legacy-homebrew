require 'formula'

class Wiggle < Formula
  url 'http://neil.brown.name/wiggle/wiggle-0.8.tar.gz'
  homepage 'http://neil.brown.name/blog/20100324064620'
  md5 '17aae004f63791faa4ff1d0e7639131d'
	
	def patches
		DATA
	end

  def install
    system "make DESTDIR=#{prefix} install"
  end
end


__END__
--- a/load.c	2011-03-17 21:18:23.000000000 -0400
+++ b/load.c	2011-03-17 21:13:25.000000000 -0400
@@ -39,6 +39,7 @@
 #include	<unistd.h>
 #include	<fcntl.h>
 #include	<malloc.h>
+#include	<stdlib.h>
 
 static void join_streams(struct stream list[], int cnt)
 {
--- a/Makefile	2010-03-24 02:31:12.000000000 -0400
+++ b/Makefile	2011-03-17 21:47:25.000000000 -0400
@@ -3,13 +3,13 @@
 #OptDbg=-O3
 #OptDbg=-O3 -march=pentium2
 OptDbg=-ggdb
-CFLAGS=$(OptDbg) -Wall -Werror
+CFLAGS=$(OptDbg) -I/usr/include/malloc -Wall -Werror
 
 # STRIP = -s
 INSTALL = /usr/bin/install
-DESTDIR = 
-BINDIR  = /usr/bin
-MANDIR  = /usr/share/man
+DESTDIR = /usr
+BINDIR  = /bin
+MANDIR  = /share/man
 MAN1DIR = $(MANDIR)/man1
 MAN5DIR = $(MANDIR)/man5
 LDLIBS = -lncurses
@@ -32,8 +32,10 @@
 	find . -name core -o -name '*.tmp*' -o -name .tmp | xargs rm -f
 
 install : wiggle wiggle.1
-	$(INSTALL) -D $(STRIP) -m 755 wiggle $(DESTDIR)$(BINDIR)/wiggle
-	$(INSTALL) -D -m 644 wiggle.1 $(DESTDIR)$(MAN1DIR)/wiggle.1
+	$(INSTALL) -d $(DESTDIR)$(BINDIR)
+	$(INSTALL) $(STRIP) -m 755 wiggle $(DESTDIR)$(BINDIR)
+	$(INSTALL) -d $(DESTDIR)$(MAN1DIR)
+	$(INSTALL) -m 644 wiggle.1 $(DESTDIR)$(MAN1DIR)
 
 version : ReadMe.c wiggle.1
 	@rm -f version
