require 'formula'

class Wput < Formula
  homepage 'http://wput.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/wput/wput/0.6.2/wput-0.6.2.tgz'
  md5 'a14c4c13d91d04d6119bdc977e8a8bdf'

  # The patch is to skip inclusion of malloc.h only on OSX. Upstream:
  # https://sourceforge.net/tracker/?func=detail&aid=3481469&group_id=141519&atid=749615
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end

  def test
    system "#{bin}/wput", "--version"
  end
end

__END__
diff --git a/src/memdbg.c b/src/memdbg.c
index 560bd7c..9e69eef 100644
--- a/src/memdbg.c
+++ b/src/memdbg.c
@@ -1,5 +1,7 @@
 #include <stdio.h>
+#ifndef __APPLE__
 #include <malloc.h>
+#endif
 #include <fcntl.h>
 #ifndef WIN32
 #include <sys/socket.h>
diff --git a/src/socketlib.c b/src/socketlib.c
index ab77d2b..c728ed9 100644
--- a/src/socketlib.c
+++ b/src/socketlib.c
@@ -20,7 +20,9 @@
  * It is meant to provide some library functions. The only required external depency
  * the printip function that is provided in utils.c */

+#ifndef __APPLE__
 #include <malloc.h>
+#endif
 #include <string.h>
 #include <fcntl.h>
 #include <errno.h>
