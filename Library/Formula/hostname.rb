class Hostname < Formula
  desc "Utility to set/show the host name or domain name"
  homepage "https://packages.debian.org/sid/hostname"
  url "https://mirrors.kernel.org/debian/pool/main/h/hostname/hostname_3.15.tar.gz"
  sha256 "b6d10114ed14306b21745d2cac1b9adf7a2546f16b9fd719bec14bd7cec61d20"

  # Add a simple strchrnul implementation since it's not available on OSX
  # and patch Makefile to use correct flags
  patch :DATA

  def install
    system "make", "install", "MANDIR=#{man}", "BINDIR=#{bin}"
  end

  test do
    system "#{bin}/hostname"
  end
end
__END__
diff -rupN -NurZ hostname/Makefile hostname.osx/Makefile
--- hostname/Makefile	2013-11-03 22:25:42.000000000 +0800
+++ hostname.osx/Makefile	2015-08-08 03:21:51.000000000 +0800
@@ -9,7 +9,7 @@ MANDIR:=/usr/share/man
 OBJS=hostname.o
 
 hostname: $(OBJS)
-	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS) -lnsl
+	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)
 	ln -fs hostname dnsdomainname
 	ln -fs hostname domainname
 	ln -fs hostname ypdomainname
@@ -17,14 +17,14 @@ hostname: $(OBJS)
 
 install: hostname
 	install -d ${BASEDIR}$(MANDIR)/man1
-	install -o root -g root -m 0644 hostname.1 ${BASEDIR}$(MANDIR)/man1
+	install -m 0644 hostname.1 ${BASEDIR}$(MANDIR)/man1
 	ln -fs hostname.1 ${BASEDIR}$(MANDIR)/man1/dnsdomainname.1
 	ln -fs hostname.1 ${BASEDIR}$(MANDIR)/man1/domainname.1
 	ln -fs hostname.1 ${BASEDIR}$(MANDIR)/man1/ypdomainname.1
 	ln -fs hostname.1 ${BASEDIR}$(MANDIR)/man1/nisdomainname.1
 
 	install -d ${BASEDIR}$(BINDIR)
-	install -o root -g root -m 0755 hostname ${BASEDIR}$(BINDIR)
+	install -m 0755 hostname ${BASEDIR}$(BINDIR)
 	ln -fs hostname ${BASEDIR}$(BINDIR)/dnsdomainname
 	ln -fs hostname ${BASEDIR}$(BINDIR)/domainname
 	ln -fs hostname ${BASEDIR}$(BINDIR)/nisdomainname
diff -rupN -NurZ hostname/hostname.c hostname.osx/hostname.c
--- hostname/hostname.c	2013-11-03 22:26:51.000000000 +0800
+++ hostname.osx/hostname.c	2015-08-08 03:08:33.000000000 +0800
@@ -46,6 +46,15 @@
 #include <rpcsvc/ypclnt.h>
 
 #define VERSION "3.15"
+char *
+strchrnul (const char *s, int c_in)
+{
+  char c = c_in;
+  while (*s && (*s != c))
+    s++;
+
+  return (char *) s;
+}
 
 enum type_t { DEFAULT, DNS, FQDN, SHORT, ALIAS, IP, NIS, NIS_DEF, ALL_FQDNS, ALL_IPS };
 
