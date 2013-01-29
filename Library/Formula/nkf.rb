require 'formula'

class Nkf < Formula
  homepage 'http://sourceforge.jp/projects/nkf/'
  url 'http://dl.sourceforge.jp/nkf/53171/nkf-2.1.2.tar.gz'
  sha1 'ca301d84e57787f566c933c2a1511f600183c8f1'

  def patches
    # Makefile patch
    DATA
  end

  def install
    ENV['prefix'] = prefix
    system 'make'
    system 'make install'
  end
end

__END__
diff --git a/Makefile b/Makefile
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,4 @@
-CC = cc
+#CC = cc
 CFLAGS = -g -O2 -Wall -pedantic
 # CFLAGS = -O3
 SHAR = shar 
@@ -7,7 +7,7 @@
 RM = rm -rf
 VERSION = 2.1.2
 MKDIR = mkdir
-prefix = /usr/local
+#prefix = /usr/local
 
 .PHONY: clean install test tar shar
 
@@ -35,13 +35,14 @@
 
 install:
 	-$(MKDIR) $(prefix)/bin
-	-$(MKDIR) $(prefix)/man
-	-$(MKDIR) $(prefix)/man/man1
-	-$(MKDIR) $(prefix)/man/ja
-	-$(MKDIR) $(prefix)/man/ja/man1
+	-$(MKDIR) $(prefix)/share
+	-$(MKDIR) $(prefix)/share/man
+	-$(MKDIR) $(prefix)/share/man/man1
+	-$(MKDIR) $(prefix)/share/man/ja
+	-$(MKDIR) $(prefix)/share/man/ja/man1
 	cp -f nkf $(prefix)/bin/
-	cp -f nkf.1 $(prefix)/man/man1/
-	cp -f nkf.1j $(prefix)/man/ja/man1/nkf.1
+	cp -f nkf.1 $(prefix)/share/man/man1/
+	cp -f nkf.1j $(prefix)/share/man/ja/man1/nkf.1
 
 shar:
 	-mkdir nkf-$(VERSION)
