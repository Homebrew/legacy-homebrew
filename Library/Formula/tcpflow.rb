require 'formula'

class Tcpflow < Formula
  url 'http://afflib.org/downloads/tcpflow-1.0.6.tar.gz'
  homepage 'http://afflib.org/software/tcpflow'
  md5 '05febeeabbbc56686dabb509fbb02e86'

  def patches
    # Patch from MacPorts
    { :p0 => DATA }
  end

  def install
    if MacOS.leopard?
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config.*"], "."
    else
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config/config.*"], "."
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

__END__
Index: src/util.c
===================================================================
--- src/util.c.orig 2011-09-25 08:25:23.000000000 -0500
+++ src/util.c 2011-10-01 20:54:36.000000000 -0500
@@ -199,6 +199,12 @@
       exit(1);
     }
 
+#if defined(__APPLE__)
+        if (limit.rlim_max > OPEN_MAX) {
+                limit.rlim_max = OPEN_MAX;
+        }
+#endif
+
     /* set the current to the maximum or specified value */
     if (max_desired_fds) limit.rlim_cur = max_desired_fds;
     else limit.rlim_cur = limit.rlim_max;
