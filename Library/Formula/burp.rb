require 'formula'

class Burp < Formula
  homepage 'http://burp.grke.org/'
  url 'https://downloads.sourceforge.net/project/burp/burp-1.4.16/burp-1.4.16.tar.bz2'
  sha1 '0b28b8989ca8ce02cfb2fb029df90be9777e3431'
  head 'https://github.com/grke/burp.git'

  bottle do
    sha1 "0ac51ee5bc80e91b28cb292e3aed223d15778926" => :mavericks
    sha1 "8b790e019ff239985a2760bb2a200672578b3b09" => :mountain_lion
    sha1 "b2efbd022a41e0ebcfe3ef015308617809b0a842" => :lion
  end

  depends_on 'librsync'

  # patches to change directories to brew conventions in Makefile and config files
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/burp",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}/burp"
    system "make", "install"
  end

  test do
    system "#{bin}/burp", "-v"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>UserName</key>
      <string>root</string>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/burp</string>
        <string>-a</string>
        <string>t</string>
      </array>
      <key>StartInterval</key>
      <integer>1200</integer>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    Before installing the launchd entry you should configure your burp client in
    #{etc}/burp/burp.conf
    EOS
  end

end

__END__
diff --git a/Makefile.in b/Makefile.in
index ac22a24..0cf112b 100755
--- a/Makefile.in
+++ b/Makefile.in
@@ -90,8 +90,8 @@ installdirs:
 	$(MKDIR) $(DESTDIR)$(sbindir)
 	$(MKDIR) $(DESTDIR)$(sysconfdir)
 	$(MKDIR) $(DESTDIR)$(sysconfdir)/CA-client
-	$(MKDIR) $(DESTDIR)/var/run
-	$(MKDIR) $(DESTDIR)/var/spool/burp
+	$(MKDIR) HOMEBREW_PREFIX/var/run
+	$(MKDIR) HOMEBREW_PREFIX/var/spool/burp
 	@if [ ! -d $(DESTDIR)$(sysconfdir)/clientconfdir ] ; then $(MKDIR) $(DESTDIR)$(sysconfdir)/clientconfdir ; cp configs/server/clientconfdir/testclient $(DESTDIR)$(sysconfdir)/clientconfdir/testclient ; fi
 	@if [ ! -d $(DESTDIR)$(sysconfdir)/clientconfdir/incexc ] ; then $(MKDIR) $(DESTDIR)$(sysconfdir)/clientconfdir/incexc ; cp configs/server/clientconfdir/incexc $(DESTDIR)$(sysconfdir)/clientconfdir/incexc/example ; fi
 	@if [ ! -d $(DESTDIR)$(sysconfdir)/autoupgrade/client ] ; then $(MKDIR) $(DESTDIR)$(sysconfdir)/autoupgrade/client ; fi
diff --git a/configs/client/burp.conf b/configs/client/burp.conf
index 1b47476..76fcd8d 100644
--- a/configs/client/burp.conf
+++ b/configs/client/burp.conf
@@ -5,7 +5,7 @@ port = 4971
 server = 127.0.0.1
 password = abcdefgh
 cname = testclient
-pidfile = /var/run/burp.client.pid
+pidfile = HOMEBREW_PREFIX/var/run/burp.client.pid
 syslog = 0
 stdout = 1
 progress_counter = 1
diff --git a/configs/server/burp.conf b/configs/server/burp.conf
index 45a4b70..c9081d0 100644
--- a/configs/server/burp.conf
+++ b/configs/server/burp.conf
@@ -3,9 +3,9 @@
 mode = server
 port = 4971
 status_port = 4972
-directory = /var/spool/burp
-clientconfdir = /etc/burp/clientconfdir
-pidfile = /var/run/burp.server.pid
+directory = HOMEBREW_PREFIX/var/spool/burp
+clientconfdir = HOMEBREW_PREFIX/etc/burp/clientconfdir
+pidfile = HOMEBREW_PREFIX/var/run/burp.server.pid
 hardlinked_archive = 0
 working_dir_recovery_method = delete
 max_children = 5
diff --git a/configs/client/burp.conf b/configs/client/burp.conf
index 76fcd8d..9cd7edb 100644
--- a/configs/client/burp.conf
+++ b/configs/client/burp.conf
@@ -41,17 +41,17 @@ cross_all_filesystems=0
 
 # Uncomment the following lines to automatically generate a certificate signing
 # request and send it to the server.
-ca_burp_ca = /usr/sbin/burp_ca
-ca_csr_dir = /etc/burp/CA-client
+ca_burp_ca = HOMEBREW_PREFIX/bin/burp_ca
+ca_csr_dir = HOMEBREW_PREFIX/etc/burp/CA-client
 
 # SSL certificate authority - same file on both server and client
-ssl_cert_ca = /etc/burp/ssl_cert_ca.pem
+ssl_cert_ca = HOMEBREW_PREFIX/etc/burp/ssl_cert_ca.pem
 
 # Client SSL certificate
-ssl_cert = /etc/burp/ssl_cert-client.pem
+ssl_cert = HOMEBREW_PREFIX/etc/burp/ssl_cert-client.pem
 
 # Client SSL key
-ssl_key = /etc/burp/ssl_cert-client.key
+ssl_key = HOMEBREW_PREFIX/etc/burp/ssl_cert-client.key
 
 # Client SSL ciphers
 #ssl_ciphers = 
