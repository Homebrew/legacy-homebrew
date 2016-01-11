class Wput < Formula
  desc "Tiny, wget-like FTP client for uploading files"
  homepage "http://wput.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/wput/wput/0.6.2/wput-0.6.2.tgz"
  sha256 "229d8bb7d045ca1f54d68de23f1bc8016690dc0027a16586712594fbc7fad8c7"

  # The patch is to skip inclusion of malloc.h only on OSX. Upstream:
  # https://sourceforge.net/tracker/?func=detail&aid=3481469&group_id=141519&atid=749615
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
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
