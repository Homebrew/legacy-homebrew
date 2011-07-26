require 'formula'

class W3m < Formula
  url 'http://downloads.sourceforge.net/project/w3m/w3m/w3m-0.5.2/w3m-0.5.2.tar.gz'
  homepage 'http://w3m.sourceforge.net/'
  md5 'ba06992d3207666ed1bf2dcf7c72bf58'

  depends_on 'bdw-gc'

  fails_with_llvm

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-image"
    system "make install"
  end

  def patches
    # GC_set_warn_proc no longer returns old proc
    DATA
  end
end

__END__
diff --git a/main.c b/main.c
index fed8c55..55fe3f1 100644
--- a/main.c
+++ b/main.c
@@ -842,7 +842,8 @@ main(int argc, char **argv, char **envp)
     mySignal(SIGPIPE, SigPipe);
 #endif
 
-    orig_GC_warn_proc = GC_set_warn_proc(wrap_GC_warn_proc);
+    orig_GC_warn_proc = GC_get_warn_proc();
+    GC_set_warn_proc(wrap_GC_warn_proc);
     err_msg = Strnew();
     if (load_argc == 0) {
 	/* no URL specified */

