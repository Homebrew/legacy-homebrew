class Burp < Formula
  desc "Network backup and restore"
  homepage "http://burp.grke.org/"
  url "https://github.com/grke/burp/archive/2.0.20.tar.gz"
  sha256 "165310395c30032623032bb593596c88e2bc8cbfa98489c0e6995ad3beda1303"
  head "https://github.com/grke/burp.git"

  bottle do
    cellar :any
    revision 2
    sha256 "bb6cf41c1f0dbbfd0a443fe3a01d5ab76ba3197625761d7fbd3c1ea1ec8a0102" => :el_capitan
    sha256 "e6a66d5a6253fd41f93e8396f9ef0b569dfa71260e23a5a021ecc775b28898ac" => :yosemite
    sha256 "c65c1af00781bd8f8b2cd2f4dbe04998b2397437c53c3a7135e3f3f2ad9f1489" => :mavericks
  end

  depends_on "librsync"
  depends_on "openssl"

  resource "uthash" do
    url "https://raw.githubusercontent.com/troydhanson/uthash/ac47d4928e61c5abc6e977d91310d31ed74690e4/src/uthash.h"
    sha256 "04dff825f3c79685b4908dd5461bc2a8ff03d9572f0f41e948b828e0c073e929"
  end

  # patches to change directories to brew conventions in Makefile and config files
  patch :DATA

  def install
    # we don't package uthash because it's only one header
    resource("uthash").stage buildpath/"uthash-include"
    ENV.append_to_cflags "-I#{buildpath}/uthash-include"

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/burp",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}/burp"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Before installing the launchd entry you should configure your burp client in
    #{etc}/burp/burp.conf
    EOS
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
index 8f93cf5..fcf95fc 100755
--- a/Makefile.in
+++ b/Makefile.in
@@ -102,8 +102,8 @@ installdirs:
 	$(MKDIR) $(DESTDIR)$(sbindir)
 	$(MKDIR) $(DESTDIR)$(sysconfdir)
 	$(MKDIR) $(DESTDIR)$(sysconfdir)/CA-client
-	$(MKDIR) $(DESTDIR)/var/run
-	$(MKDIR) $(DESTDIR)/var/spool/burp
+	$(MKDIR) HOMEBREW_PREFIX/var/run
+	$(MKDIR) HOMEBREW_PREFIX/var/spool/burp
 	$(MKDIR) $(DESTDIR)$(sysconfdir)/clientconfdir
 	$(MKDIR) $(DESTDIR)$(sysconfdir)/clientconfdir/incexc
 	$(MKDIR) $(DESTDIR)$(sysconfdir)/autoupgrade/client
diff --git a/configs/client/burp.conf b/configs/client/burp.conf
index f17eda6..d84ec32 100644
--- a/configs/client/burp.conf
+++ b/configs/client/burp.conf
@@ -11,7 +11,7 @@ cname = testclient
 # with a pseudo mirrored storage on the server and optional rsync). 2 forces
 # protocol2 mode (inline deduplication with variable length blocks).
 # protocol = 0
-pidfile = @runstatedir@/burp.client.pid
+pidfile = HOMEBREW_PREFIX/var/run/burp.client.pid
 syslog = 0
 stdout = 1
 progress_counter = 1
diff --git a/configs/server/burp.conf b/configs/server/burp.conf
index 1cc534f..fbda82a 100644
--- a/configs/server/burp.conf
+++ b/configs/server/burp.conf
@@ -12,7 +12,7 @@ port = 4971
 # If you do not wish to run a status server at all, comment status_port out.
 status_port = 4972
 
-directory = /var/spool/burp
+directory = HOMEBREW_PREFIX/var/spool/burp
 dedup_group = global
 clientconfdir = @sysconfdir@/clientconfdir
 # Choose the protocol to use.
@@ -22,7 +22,7 @@ clientconfdir = @sysconfdir@/clientconfdir
 # Like many other settings, this can be set per client in the clientconfdir
 # files.
 # protocol = 0
-pidfile = @runstatedir@/burp.server.pid
+pidfile = HOMEBREW_PREFIX/var/run/burp.server.pid
 hardlinked_archive = 0
 working_dir_recovery_method = delete
 max_children = 5
