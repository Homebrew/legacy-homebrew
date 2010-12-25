require 'formula'

class Luit <Formula
  url 'http://xorg.freedesktop.org/archive/individual/app/luit-1.1.0.tar.gz'
  homepage 'http://www.x.org/'
  md5 'd7f8ccf45081db086e91ce9940248fc7'

  depends_on 'pkg-config' => :build

  # Patch to fix https://bugs.freedesktop.org/show_bug.cgi?id=27931
  def patches
    DATA
  end

  def install
    system "mkdir -p #{share}/X11/locale"
    ln_s "/usr/X11/share/X11/locale/locale.alias", "#{share}/X11/locale/locale.alias"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
__END__
diff --git a/luit.c b/luit.c
index 6bd8775..614fbe4 100644
--- a/luit.c
+++ b/luit.c
@@ -60,7 +60,12 @@ int ilog = -1;
 int olog = -1;
 int verbose = 0;
 
-static volatile int sigwinch_queued = 0;
+#ifdef __APPLE__
+    static volatile int sigwinch_queued = 1;
+#else
+    static volatile int sigwinch_queued = 0;
+#endif
+
 static volatile int sigchld_queued = 0;
 
 static int convert(int, int);
