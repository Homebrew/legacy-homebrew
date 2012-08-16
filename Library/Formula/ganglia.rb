require 'formula'

class Ganglia < Formula
  homepage 'http://ganglia.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.1.7/ganglia-3.1.7.tar.gz'
  md5 '6aa5e2109c2cc8007a6def0799cf1b4c'

  depends_on :automake
  depends_on :libtool

  depends_on 'confuse'
  depends_on 'pcre'
  depends_on 'rrdtool'

  def patches
    # fixes build on Leopard and newer, which lack kvm.h and its corresponding /dev/ node
    # Patch sent upstream: http://bugzilla.ganglia.info/cgi-bin/bugzilla/show_bug.cgi?id=258
    # Also, for some reason, having inline or static keywords in gperf generated files
    # causes missing symbol link errors - manually patch those out for now.
    DATA
  end

  def install
    # ENV var needed to confirm putting the config in the prefix until 3.2
    ENV['GANGLIA_ACK_SYSCONFDIR'] = '1'

    # Grab the standard autogen.sh and run it twice, to update libtool
    curl "http://buildconf.git.sourceforge.net/git/gitweb.cgi?p=buildconf/buildconf;a=blob_plain;f=autogen.sh;hb=HEAD", "-o", "autogen.sh"

    ENV['LIBTOOLIZE'] = "/usr/bin/glibtoolize" if MacOS::Xcode.provides_autotools?
    ENV['PROJECT'] = "ganglia"
    system "/bin/sh ./autogen.sh --download"

    cd "libmetrics" do
      ENV['PROJECT'] = "libmetrics"
      system "/bin/sh ../autogen.sh --download"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--with-gexec",
                          "--with-gmetad",
                          "--with-libpcre=#{HOMEBREW_PREFIX}"
    system "make install"

    cd "web" do
      system "make", "conf.php"
      system "make", "version.php"
      inreplace "conf.php", "/usr/bin/rrdtool", "#{HOMEBREW_PREFIX}/bin/rrdtool"
    end

    # Generate the default config file
    system "#{bin}/gmond -t > #{etc}/gmond.conf" unless File.exists? "#{etc}/gmond.conf"

    # Install the web files
    (share+"ganglia").install "web"

    # Install man pages
    man1.install Dir['mans/*']
  end

  def caveats; <<-EOS.undent
    If you didn't have a default config file, one was created here:
      #{etc}/gmond.conf

    You might want to copy these someplace served by a PHP-capable web server:
      #{share}/ganglia/web/* to someplace
    EOS
  end
end

__END__
diff --git a/libmetrics/config.h.in b/libmetrics/config.h.in
index 1ff64b1..13087c6 100644
--- a/libmetrics/config.h.in
+++ b/libmetrics/config.h.in
@@ -152,6 +152,9 @@
 /* Define to 1 if you have the <sys/fs/s5param.h> header file. */
 #undef HAVE_SYS_FS_S5PARAM_H
 
+/* Define to 1 if you have the <kvm.h> header file. */
+#undef HAVE_KVM_H
+
 /* Define to 1 if you have the <sys/mount.h> header file. */
 #undef HAVE_SYS_MOUNT_H
 
diff --git a/libmetrics/configure.in b/libmetrics/configure.in
index 213d162..b5aa98e 100644
--- a/libmetrics/configure.in
+++ b/libmetrics/configure.in
@@ -31,7 +31,7 @@ AC_HAVE_LIBRARY(nsl)
 # Checks for header files.
 AC_HEADER_DIRENT
 AC_HEADER_STDC
-AC_CHECK_HEADERS([fcntl.h inttypes.h limits.h nlist.h paths.h stdlib.h strings.h sys/filsys.h sys/fs/s5param.h sys/mount.h sys/param.h sys/socket.h sys/statfs.h sys/statvfs.h sys/systeminfo.h sys/time.h sys/vfs.h unistd.h utmp.h sys/sockio.h])
+AC_CHECK_HEADERS([fcntl.h inttypes.h limits.h nlist.h paths.h stdlib.h strings.h sys/filsys.h sys/fs/s5param.h sys/mount.h sys/param.h sys/socket.h sys/statfs.h sys/statvfs.h sys/systeminfo.h sys/time.h sys/vfs.h unistd.h utmp.h sys/sockio.h kvm.h])
 AC_CHECK_HEADERS([rpc/rpc.h],, 
    [AC_MSG_ERROR([your system is missing the Sun RPC (ONC/RPC) libraries])])
 
diff --git a/libmetrics/darwin/metrics.c b/libmetrics/darwin/metrics.c
index 498ed8f..bfa09a1 100644
--- a/libmetrics/darwin/metrics.c
+++ b/libmetrics/darwin/metrics.c
@@ -9,9 +9,17 @@
  *
  */
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <stdlib.h>
 #include "interface.h"
+
+#if defined(HAVE_LIBKVM) && defined(HAVE_KVM_H)
 #include <kvm.h>
+#endif
+
 #include <sys/sysctl.h>
 
 #include <mach/mach_init.h>

diff --git a/gmetad/type_hash.c b/gmetad/type_hash.c
index 519513d..3f65efa 100644
--- a/gmetad/type_hash.c
+++ b/gmetad/type_hash.c
@@ -46,14 +46,7 @@ struct type_tag;
 #define MAX_HASH_VALUE 21
 /* maximum key range = 18, duplicates = 0 */
 
-#ifdef __GNUC__
-__inline
-#else
-#ifdef __cplusplus
-inline
-#endif
-#endif
-static unsigned int
+unsigned int
 type_hash (str, len)
      register const char *str;
      register unsigned int len;
@@ -124,12 +117,6 @@ static struct type_tag types[] =
     {"double", FLOAT}
   };
 
-#ifdef __GNUC__
-__inline
-#ifdef __GNUC_STDC_INLINE__
-__attribute__ ((__gnu_inline__))
-#endif
-#endif
 struct type_tag *
 in_type_list (str, len)
      register const char *str;
diff --git a/gmetad/xml_hash.c b/gmetad/xml_hash.c
index 5c21755..04910b3 100644
--- a/gmetad/xml_hash.c
+++ b/gmetad/xml_hash.c
@@ -42,13 +42,6 @@ struct xml_tag;
 #define MAX_HASH_VALUE 44
 /* maximum key range = 42, duplicates = 0 */
 
-#ifdef __GNUC__
-__inline
-#else
-#ifdef __cplusplus
-inline
-#endif
-#endif
 static unsigned int
 xml_hash (str, len)
      register const char *str;
@@ -86,12 +79,6 @@ xml_hash (str, len)
   return len + asso_values[(unsigned char)str[len - 1]] + asso_values[(unsigned char)str[0]];
 }
 
-#ifdef __GNUC__
-__inline
-#ifdef __GNUC_STDC_INLINE__
-__attribute__ ((__gnu_inline__))
-#endif
-#endif
 struct xml_tag *
 in_xml_list (str, len)
      register const char *str;
