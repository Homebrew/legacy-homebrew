require 'formula'

class Dnsmap < Formula
  homepage 'http://code.google.com/p/dnsmap/'
  url 'https://dnsmap.googlecode.com/files/dnsmap-0.30.tar.gz'
  sha1 'a9a8a17102825510d16c1f8af33ca74407c18c70'
  patch :DATA, :p0

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "BINDIR=#{bin}", "install"
  end
end

__END__
diff --git a/dnsmap.c b/dnsmap.c
--- a/dnsmap.c
+++ b/dnsmap.c
@@ -748,7 +748,7 @@ unsigned short int isIPblacklisted(char *ip) {
 // updated in the future to detect other common public DNS servers
 unsigned short int usesOpenDNS(char *ipstr) {
         char strTmp[30]={'\0'}, s[MAXSTRSIZE]={'\0'}, dummyLTD[4]={"xyz"}/*, ipstr[INET_ADDRSTRLEN]={'\0'}*/;
-	char ips[][INET_ADDRSTRLEN]={"67.215.65.132"};
+	char ips[][INET_ADDRSTRLEN]={"8.8.8.8"};
         unsigned short int i=0,j=0,n=0,max=0;
 	struct hostent *h;
