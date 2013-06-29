require 'formula'

class Gmediaserver < Formula
  homepage 'http://www.gnu.org/software/gmediaserver/'
  url 'http://download.savannah.gnu.org/releases/gmediaserver/gmediaserver-0.13.0.tar.gz'
  sha1 '5b868bc3c3d3bf0c2c550a4fc618c586a2640799'

  depends_on 'pkg-config' => :build
  depends_on 'libupnp'
  depends_on 'libmagic'
  depends_on 'id3lib' => :optional
  depends_on 'taglib' => :optional

  def patches
    # patching gmediaserver because sigwaitinfo is not available on
    # mac os x snow leopard, using sigwait instead
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
--- gmediaserver-0.13.0 CHANGED/src/metadata.c	2007-10-20 11:41:32.000000000 +0200
+++ gmediaserver-0.13.0/src/metadata.c	2009-12-20 23:06:57.000000000 +0100
@@ -1018,7 +1018,7 @@
 bool
 init_metadata(void)
 {
-    magic_cookie = magic_open(MAGIC_SYMLINK|MAGIC_MIME|MAGIC_ERROR);
+    magic_cookie = magic_open(MAGIC_SYMLINK|MAGIC_MIME_TYPE|MAGIC_ERROR);
     if (magic_cookie == NULL) {
         warn(_("cannot initialize magic library\n"));
         return false;
--- a/src/main.c	2007-10-20 11:41:37.000000000 +0200
+++ b/src/main.c	2009-12-20 20:39:58.000000000 +0100
@@ -447,8 +447,8 @@
     	int sig;
     	char signame[SIG2STR_MAX];
 
-      	if ((sig = TEMP_FAILURE_RETRY(sigwaitinfo(&signalset, NULL))) < 0)
-    	    die(_("sigwaitinfo failed - %s\n"), errstr);
+      	if (TEMP_FAILURE_RETRY(sigwait(&signalset, &sig)) < 0)
+    	    die(_("sigwait failed - %s\n"), errstr);
         if (sig2str(sig, signame) == 0)
       	    say(2, _("Received %s signal\n"), signame);
       	else
