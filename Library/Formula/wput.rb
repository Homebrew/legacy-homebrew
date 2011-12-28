require 'formula'

class Wput < Formula
  url 'http://downloads.sourceforge.net/project/wput/wput/0.6.1/wput-0.6.1.tgz'
  homepage 'http://wput.sourceforge.net/'
  md5 '92b41efed4db8eb4f3443c23bf7ceecf'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end

  def test
    system "wput --version"
  end

  def patches
    DATA
  end
end
__END__
commit 876dd41b1ac0d6284462ad21e8e66c1c4672f078
Author: Chris Cosby <chris@microcozm.net>
Commit: Chris Cosby <chris@microcozm.net>

    ifdef malloc.h for OSX
    Create directories

diff --git a/Makefile.in b/Makefile.in
index 452de0d..86a403e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -16,6 +16,7 @@ win-clean:
 
 install: all
 	cd po && $(MAKE) $(MAKEDEFS) $@
+	-install -d -m0755 $(bindir) $(mandir)
 	install -m0755 wput $(bindir)
 	install -m0644 doc/wput.1.gz $(mandir)
 	@echo "----------------"
diff --git a/src/memdbg.c b/src/memdbg.c
index 560bd7c..784c0fe 100644
--- a/src/memdbg.c
+++ b/src/memdbg.c
@@ -1,5 +1,7 @@
 #include <stdio.h>
+#if !defined(__APPLE__)
 #include <malloc.h>
+#endif
 #include <fcntl.h>
 #ifndef WIN32
 #include <sys/socket.h>
diff --git a/src/socketlib.c b/src/socketlib.c
index daf3a7d..82d7af4 100644
--- a/src/socketlib.c
+++ b/src/socketlib.c
@@ -20,7 +20,9 @@
  * It is meant to provide some library functions. The only required external depency
  * the printip function that is provided in utils.c */
 
+#if !defined(__APPLE__)
 #include <malloc.h>
+#endif
 #include <string.h>
 #include <fcntl.h>
 #ifndef WIN32
