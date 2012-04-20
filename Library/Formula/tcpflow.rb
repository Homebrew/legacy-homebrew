require 'formula'

class Tcpflow < Formula
  homepage 'https://github.com/simsong/tcpflow'
  url 'https://github.com/downloads/simsong/tcpflow/tcpflow-1.2.6.tar.gz'
  md5 '7562f8a1a65f1ce1238be84a1fe83bf6'

  # Patch from MacPorts
  def patches; DATA; end

  def install
    if MacOS.leopard?
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config.*"], "."
    else
      cp Dir["#{MacOS.xcode_prefix}/usr/share/libtool/config/config.*"], "."
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
--- a/src/tcpip.cpp  
+++ b/src/tcpip.cpp
@@ -541,6 +541,12 @@ unsigned int tcpdemux::get_max_fds(void)
 	    perror("getrlimit");
 	    exit(1);
 	}
+ 
+#if defined(__APPLE__)
+	if (limit.rlim_max > OPEN_MAX) {
+		limit.rlim_max = OPEN_MAX;
+	}
+#endif
 
 	/* set the current to the maximum or specified value */
 	if (max_desired_fds) limit.rlim_cur = max_desired_fds;
