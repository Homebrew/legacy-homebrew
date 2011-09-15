require 'formula'

class SyslogNg < Formula
  url 'http://www.balabit.com/downloads/files?path=/syslog-ng/sources/3.2.4/source/syslog-ng_3.2.4.tar.gz'
  homepage 'http://www.balabit.com/network-security/syslog-ng/'
  md5 '5995f7dad0053a478b60a63f6f754203'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'eventlog'
  depends_on 'glib'

  def patches; DATA; end

  def install
    ENV.append 'LDFLAGS', '-levtlog -lglib-2.0' # help the linker find symbols
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-dynamic-linking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make install"
  end
end

__END__
Fix for environ on OS X, by @adamv

diff --git a/lib/gprocess.c b/lib/gprocess.c
index 38bcb12..ed68a7f 100644
--- a/lib/gprocess.c
+++ b/lib/gprocess.c
@@ -51,6 +51,9 @@
 #  include <sys/prctl.h>
 #endif
 
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron())
+
 /*
  * NOTES:
  * 
@@ -440,7 +443,6 @@ g_process_set_caps(const gchar *caps)
 void
 g_process_set_argv_space(gint argc, gchar **argv)
 {
-  extern char **environ;
   gchar *lastargv = NULL;
   gchar **envp    = environ;
   gint i;
