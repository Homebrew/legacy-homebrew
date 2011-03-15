require 'formula'

class Splint < Formula
  url 'http://www.splint.org/downloads/splint-3.1.2.src.tgz'
  homepage 'http://www.splint.org/'
  md5 '25f47d70bd9c8bdddf6b03de5949c4fd'

  def patches
    # fix compiling error of osd.c
    DATA
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}", "--mandir=#{man}"
    system "make"
    ENV.j1 # Install fails on 8-core without this.
    system "make install"
  end
end


__END__
diff --git a/src/osd.c b/src/osd.c
index ebe214a..4ba81d5 100644
--- a/src/osd.c
+++ b/src/osd.c
@@ -516,7 +516,7 @@ osd_getPid ()
 # if defined (WIN32) || defined (OS2) && defined (__IBMC__)
   int pid = _getpid ();
 # else
-  __pid_t pid = getpid ();
+  pid_t pid = getpid ();
 # endif

   return (int) pid;
