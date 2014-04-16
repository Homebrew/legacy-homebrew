require 'formula'

class Bgpq3 < Formula
  homepage 'http://snar.spb.ru/prog/bgpq3/'
  url 'http://snar.spb.ru/prog/bgpq3/bgpq3-0.1.19.tgz'
  sha1 '41a2afaeffb12e43048ca8771c6cc6e6392e0da5'
  head "https://github.com/snar/bgpq3.git"

  # Makefile: upstream has been informed of the patch through email,
  # but no plans yet to incorporate it
  # https://github.com/snar/bgpq3/pull/2
  # strlcpy.c patch: upstream accepted but has not yet created a release
  # https://github.com/snar/bgpq3/commit/89d864
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpq3", "AS-ANY"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index c2d7e96..afec780 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -29,9 +29,10 @@ clean:
 	rm -rf *.o *.core core.* core

 install: bgpq3
+	if test ! -d @prefix@/bin ; then mkdir -p @prefix@/bin ; fi
 	${INSTALL} -c -s -m 755 bgpq3 @bindir@
-	if test ! -d @prefix@/man/man8 ; then mkdir -p @prefix@/man/man8 ; fi
-	${INSTALL} -m 644 bgpq3.8 @prefix@/man/man8
+	if test ! -d @mandir@/man8 ; then mkdir -p @mandir@/man8 ; fi
+	${INSTALL} -m 644 bgpq3.8 @mandir@/man8

 depend:
 	makedepend -- $(CFLAGS) -- $(SRCS)
diff --git a/strlcpy.c b/strlcpy.c
index 6d4b7b0..f66dc42 100644
--- a/strlcpy.c
+++ b/strlcpy.c
@@ -27,6 +27,10 @@
  * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */

+#if HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #ifndef HAVE_STRLCPY

 #include <sys/types.h>
