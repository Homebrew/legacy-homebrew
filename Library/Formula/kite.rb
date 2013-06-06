require 'formula'

class Kite < Formula
  homepage 'http://www.kite-language.org/'
  url 'http://www.kite-language.org/files/kite-1.0.4.tar.gz'
  sha1 '9db2adbcc3acac5f06d495002a344e613c81c3f2'

  depends_on 'bdw-gc'

  # patch to build against bdw-gc 7.2, sent upstream
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/backend/common/kite_vm.c	2010-08-21 01:20:25.000000000 +0200
+++ b/backend/common/kite_vm.c	2012-02-11 02:29:37.000000000 +0100
@@ -152,7 +152,12 @@
 #endif
 
 #ifdef HAVE_GC_H
+#if GC_VERSION_MAJOR >= 7 && GC_VERSION_MINOR >= 2
+    ret->old_proc = GC_get_warn_proc();
+    GC_set_warn_proc ((GC_warn_proc)kite_ignore_gc_warnings);
+#else
     ret->old_proc = GC_set_warn_proc((GC_warn_proc)kite_ignore_gc_warnings);
+#endif
 #endif /* HAVE_GC_H */
 
     return ret;
