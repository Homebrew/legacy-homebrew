require 'formula'

class Mp3info < Formula
  url 'http://www.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/mp3info-0.8.5a.tgz'
  homepage 'http://www.ibiblio.org/mp3info/'
  md5 'cb7b619a10a40aaac2113b87bb2b2ea2'

  def patches
    DATA
  end

  def install
    system "make"
    bin.install "mp3info"
    man1.install "mp3info.1"
  end
end

__END__
--- mp3info-0.8.5a/mp3tech.c	2006-11-06 05:05:30.000000000 +0100
+++ mp3tech.c	2011-11-06 20:32:15.000000000 +0100
@@ -279,7 +279,7 @@
 }
 
 int sameConstant(mp3header *h1, mp3header *h2) {
-    if((*(uint*)h1) == (*(uint*)h2)) return 1;
+    if((*(unsigned int*)h1) == (*(unsigned int*)h2)) return 1;
 
     if((h1->version       == h2->version         ) &&
        (h1->layer         == h2->layer           ) &&
--- mp3info-0.8.5a/Makefile	2006-11-10 01:14:11.000000000 +0100
+++ Makefile	2011-11-06 20:32:09.000000000 +0100
@@ -47,7 +47,7 @@
 CC = gcc
 CFLAGS = -g -O2 -Wall
 
-all: mp3info gmp3info doc
+all: mp3info doc
 
 doc: mp3info.txt
 
@@ -77,7 +77,7 @@
 	$(STRIP) gmp3info
 	$(INSTALL) gmp3info $(bindir)/gmp3info
 
-install: install-mp3info install-gmp3info
+install: install-mp3info
 
 
 uninstall:
