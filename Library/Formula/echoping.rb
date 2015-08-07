class Echoping < Formula
  desc "Small test tool for TCP servers"
  homepage "http://echoping.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/echoping/echoping/6.0.2/echoping-6.0.2.tar.gz"
  sha256 "6a06db4c7dc6d8a906613a2ed6027c28cdf1fe5d8b82c844344c3d7b9d1b2c75"

  depends_on "popt"
  depends_on "libidn"

  # Fixes a DNS issue with header files, taken from Macports
  # https://trac.macports.org/browser/trunk/dports/net/echoping/files/patch-plugins-dns-dns.c.diff
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--config-cache",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end


__END__
diff --git a/plugins/dns/dns.c b/plugins/dns/dns.c
index 9730913..966f51a 100644
--- a/plugins/dns/dns.c
+++ b/plugins/dns/dns.c
@@ -9,6 +9,7 @@
 #endif
 #include <netinet/in.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser_compat.h>
 #include <resolv.h>
 
 struct addrinfo name_server;
