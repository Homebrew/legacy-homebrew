require 'formula'

class AptDater < Formula
  homepage 'http://www.ibh.de/apt-dater/'
  url 'http://downloads.sourceforge.net/project/apt-dater/apt-dater/0.8.6/apt-dater-0.8.6.tar.gz'
  md5 '1f1b92403b9afb74032254ed47e7bce3'

  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'popt'

  # bug report:
  # http://sourceforge.net/tracker/?func=detail&aid=3470631&group_id=233727&atid=1091021
  def patches
    { :p0 => DATA }
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "AM_LDFLAGS=", "install"
  end

  def test
    system "#{bin}/apt-dater", "-v"
  end
end

__END__
--- src/apt-dater.c
+++ src/apt-dater.c
@@ -180,10 +180,10 @@ int main(int argc, char **argv, char **envp)
  if(!report) {
 #endif
    /* Test if we are the owner of the TTY or die. */
-   if(g_access("/proc/self/fd/0", R_OK|W_OK)) {
-     g_error(_("Cannot open your terminal /proc/self/fd/0 - please check."));
-     exit(EXIT_FAILURE);
-   }
+//   if( g_access("/proc/self/fd/0", R_OK|W_OK)) {
+//     g_error(_("Cannot open your terminal /proc/self/fd/0 - please check."));
+//     exit(EXIT_FAILURE);
+//   }
 
    getOldestMtime(hosts);
 
--- src/stats.c
+++ src/stats.c
@@ -96,6 +96,9 @@ gboolean setStatsFileFromIOC(GIOChannel *ioc, GIOCondition condition,
     if(iostatus == G_IO_STATUS_ERROR || iostatus == G_IO_STATUS_AGAIN)
      break;
 
+    if(*buf == 0)
+     condition = G_IO_HUP;
+
     if(fwrite(buf, sizeof(gchar), bytes, ((HostNode *) n)->fpstat) != bytes)
 	break;
