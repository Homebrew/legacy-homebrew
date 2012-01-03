require 'formula'

class Tinycc < Formula
  url 'http://download.savannah.nongnu.org/releases/tinycc/tcc-0.9.25.tar.bz2'
  homepage 'http://bellard.org/tcc/'
  md5 '991c2a1986cce15f03ca6ddc86ea5f43'

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

# Make it compile in OSX
# Patch was found here: http://stackoverflow.com/questions/3712902/problems-compiling-tcc-on-os-x
__END__
diff -u a/libtcc.c b/libtcc.c
--- a/libtcc.c	2012-01-03 12:13:47.000000000 -0500
+++ b/libtcc.c	2012-01-03 12:14:39.000000000 -0500
@@ -1508,11 +1508,18 @@
     int i;
 
     if (level == 0) {
-        /* XXX: only support linux */
+#ifdef __DARWIN_UNIX03
+        *paddr = uc->uc_mcontext->__ss.__rip;
+#else
         *paddr = uc->uc_mcontext.gregs[REG_RIP];
+#endif
         return 0;
     } else {
+#ifdef __DARWIN_UNIX03
+        fp = uc->uc_mcontext->__ss.__rbp;
+#else
         fp = uc->uc_mcontext.gregs[REG_RBP];
+#endif
         for(i=1;i<level;i++) {
             /* XXX: check address validity with program info */
             if (fp <= 0x1000)

