require 'formula'

class Echoping < Formula
  homepage 'http://echoping.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/echoping/echoping/6.0.2/echoping-6.0.2.tar.gz'
  md5 '991478532b56ab3b6f46ea9fa332626f'

  depends_on 'popt'
  depends_on 'libidn'

  # Fixes a DNS issue with header files, taken from Macports
  # https://trac.macports.org/browser/trunk/dports/net/echoping/files/patch-plugins-dns-dns.c.diff
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--config-cache",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
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
