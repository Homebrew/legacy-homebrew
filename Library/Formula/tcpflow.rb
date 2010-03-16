require 'formula'

class Tcpflow <Formula
  url 'http://www.circlemud.org/pub/jelson/tcpflow/tcpflow-0.21.tar.gz'
  homepage 'http://www.circlemud.org/~jelson/software/tcpflow/'
  md5 '45a5aef6f043312315b7f342afc4a9c5'

  depends_on 'libpcap'

  def patches
    DATA
  end

  def install
    FileUtils.cp "/Developer/usr/share/libtool/config/config.guess", "config.guess"
    FileUtils.cp "/Developer/usr/share/libtool/config/config.sub", "config.sub"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--mandir=#{man}"
    system "make install"
  end
end

__END__
--- a/src/util.c	2001-08-09 05:39:40.000000000 +1000
+++ b/src/util.c	2008-12-27 18:12:52.000000000 +1100
@@ -181,6 +181,12 @@ int get_max_fds(void)
       exit(1);
     }
 
+#if defined(__APPLE__)
+	if (limit.rlim_max > OPEN_MAX) {
+		limit.rlim_max = OPEN_MAX;
+	}
+#endif
+
     /* set the current to the maximum or specified value */
     if (max_desired_fds)
       limit.rlim_cur = max_desired_fds;
