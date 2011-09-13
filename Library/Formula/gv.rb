require 'formula'

class Gv < Formula
  url 'http://ftpmirror.gnu.org/gv/gv-3.7.2.tar.gz'
  homepage 'http://www.gnu.org/s/gv/'
  md5 'eb47d465755b7291870af66431c6f2e1'

  depends_on 'ghostscript'
  depends_on 'xaw3d'
  skip_clean 'share/gv/safe-gs-workdir'

  def patches
    DATA
  end

  def install
    ENV.x11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-SIGCHLD-fallback"
    system "make install"
  end
end

__END__
# as in https://trac.macports.org/export/83941/trunk/dports/print/gv/files/patch-src-callbacks.c.diff
diff --git a/src/callbacks.c b/src/callbacks.c
index 00a3ad8..84f2cf0 100644
--- a/src/callbacks.c
+++ b/src/callbacks.c
@@ -1031,6 +1031,7 @@ cb_presentation(w, client_data, call_data)
     XtPointer client_data, call_data;
 {
     int pid;
+    typedef void (*sighandler_t)(int);
     sighandler_t sigold;

     BEGINMESSAGE(cb_presentation)
