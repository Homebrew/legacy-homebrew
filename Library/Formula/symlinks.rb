require 'formula'

class Symlinks < Formula
  homepage 'http://www.ibiblio.org/pub/Linux/utils/file/symlinks.lsm'
  url 'http://www.ibiblio.org/pub/Linux/utils/file/symlinks-1.4.tar.gz'
  md5 'c38ef760574c25c8a06fd2b5b141307d'

  def install
    system "make"
    system "make PREFIX=#{prefix} MANDIR=#{man} install"
  end

  def test
    mktemp do
      system "#{bin}/symlinks -v ."
    end
  end
  
  def patches
    # remove use of malloc.h and fix Makefile to use PREFIX and MANDIR
    DATA
  end

end

__END__
diff --git a/Makefile b/Makefile
index f305449..ce6cc0b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,15 +1,18 @@
 # Makefile for symlinks
 
-CC = gcc
+PREFIX ?= /usr/local
+MANPATH ?= /usr/local/man
  
 all: symlinks
 
 symlinks: symlinks.c
-	$(CC) -Wall -Wstrict-prototypes -O2 ${CFLAGS} -o symlinks symlinks.c
+	$(CC) ${CFLAGS} -o symlinks symlinks.c
  
 install: all symlinks.8
-	install -m 755 -o root -g root symlinks /usr/local/bin
-	install -m 644 -o root -g root symlinks.8 /usr/local/man/man8
+	install -d ${PREFIX}/bin
+	install -d ${MANDIR}/man8
+	install -m 755 symlinks ${PREFIX}/bin
+	install -m 644 symlinks.8 ${MANDIR}/man8
 
 clean:
 	rm -f symlinks *.o core
diff --git a/symlinks.c b/symlinks.c
index 2b2452a..5efae01 100644
--- a/symlinks.c
+++ b/symlinks.c
@@ -4,7 +4,6 @@
 #endif
 #include <stdio.h>
 #include <stdlib.h>
-#include <malloc.h>
 #include <string.h>
 #include <fcntl.h>
 #include <sys/param.h>
