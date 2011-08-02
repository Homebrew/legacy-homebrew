require 'formula'

class Jwhois < Formula
  url 'http://ftp.gnu.org/pub/gnu/jwhois/jwhois-4.0.tar.gz'
  homepage 'http://directory.fsf.org/project/jwhois/'
  md5 '977d0ba90ee058a7998c94d933fc9546'

  # No whois entry in /etc/services. Use nicname instead.
  def patches; DATA; end

  def install
    # link fails on libiconv if not added here
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "LIBS=-liconv"
    system "make install"
  end
end


__END__
diff --git a/src/dns.c b/src/dns.c
index a818237..b5fe9c8 100644
--- a/src/dns.c
+++ b/src/dns.c
@@ -113,7 +113,7 @@ int
 lookup_host_addrinfo(struct addrinfo **res, const char *host, int port)
 {
   struct addrinfo hints;
-  char ascport[10] = "whois";
+  char ascport[10] = "nicname";
   int error;
 
   memset(&hints, 0, sizeof(hints));
