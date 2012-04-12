require 'formula'

class Tcpflow < Formula
  homepage 'http://afflib.org/software/tcpflow'
  url 'http://afflib.org/downloads/tcpflow-1.1.0.tar.gz'
  md5 '9b836b16575679e9d10f39ac7a98efbe'

  # Patch from MacPorts
  def patches; DATA; end

  def install
    if MacOS.leopard?
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config.*"], "."
    else
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config/config.*"], "."
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
--- a/src/util.cpp	2012-02-07 14:42:10.000000000 +1100
+++ b/src/util.cpp	2012-02-07 14:42:12.000000000 +1100
@@ -114,6 +114,12 @@
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
