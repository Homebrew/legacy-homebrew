require 'formula'

class Splint < Formula
  homepage 'http://www.splint.org/'
  url 'http://www.splint.org/downloads/splint-3.1.2.src.tgz'
  sha1 '0df489cb228dcfffb149b38c57614c2c3e200501'

  def patches
    # fix compiling error of osd.c
    DATA
  end

  def install
    ENV.j1 # build is not parallel-safe
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make"
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
