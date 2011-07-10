require 'formula'

class Mp3info < Formula
  url 'ftp://ftp.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/mp3info-0.8.5a.tgz'
  homepage 'http://www.ibiblio.org/mp3info/'
  md5 'cb7b619a10a40aaac2113b87bb2b2ea2'
  
  def patches
    # fix compiling on leopard (from macports)
    DATA
  end
  
  def install
    man.mkpath
    bin.mkpath
    system "make mp3info"
    system "make install-mp3info prefix=#{prefix} mandir=#{man}"
  end
end

__END__
3tech.c.diff
--- ../mp3tech.c	2006-11-05 22:05:30.000000000 -0600
+++ mp3tech.c	2007-11-30 12:28:52.000000000 -0600
@@ -279,7 +279,7 @@
 }
 
 int sameConstant(mp3header *h1, mp3header *h2) {
-    if((*(uint*)h1) == (*(uint*)h2)) return 1;
+    if((*(unsigned int*)h1) == (*(unsigned int*)h2)) return 1;
 
     if((h1->version       == h2->version         ) &&
        (h1->layer         == h2->layer           ) &&