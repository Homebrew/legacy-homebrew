require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
#                /Users/alet/Documents/Source/homebrew/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Oinkmaster < Formula
  homepage 'http://oinkmaster.sourceforge.net/'
  url 'http://switch.dl.sourceforge.net/project/oinkmaster/oinkmaster/2.0/oinkmaster-2.0.tar.gz'
  version '2.0'
  sha1 '01a0d774195670a11af5ff3e302773d962b34224'

  # depends_on 'cmake' => :build
  depends_on 'suricata'

  def patches
	DATA 
  end

  def install
    system "install" # if this fails, try separate make/make install steps
  end

  def caveats
	  "Update rules for suricata by command 'oinkmaster -o ${path}/suricata/rules'"
  end

end

__END__
diff -Nru oinkmaster-2.0.orig/Makefile oinkmaster-2.0/Makefile
--- oinkmaster-2.0.orig/Makefile	1970-01-01 03:00:00.000000000 +0300
+++ oinkmaster-2.0/Makefile	2013-09-28 16:50:51.000000000 +0300
@@ -0,0 +1,7 @@
+install:
+	$(INSTALL_DIR) "$(DESTDIR)/etc"
+	$(INSTALL_DATA) oinkmaster.conf "$(DESTDIR)/etc"
+	$(INSTALL_DIR) "$(DESTDIR)/man1"
+	$(INSTALL_DATA) oinkmaster.1 "$(DESTDIR)/man1"
+	$(INSTALL_DIR) "$(DESTDIR)/bin"
+	$(INSTALL_DATA) oinkmaster.pl "$(DESTDIR)/bin"
diff -Nru oinkmaster-2.0.orig/oinkmaster.conf oinkmaster-2.0/oinkmaster.conf
--- oinkmaster-2.0.orig/oinkmaster.conf	2006-02-18 14:35:21.000000000 +0200
+++ oinkmaster-2.0/oinkmaster.conf	2013-09-27 14:04:20.000000000 +0300
@@ -79,6 +79,8 @@
 # OpenSSH manual. 
 # scp_key = /home/oinkmaster/oinkmaster_privkey
 
+# Emerging threats rules for suricata
+url = http://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz
 
 # The PATH to use during execution. If you prefer to use external 
 # binaries (i.e. use_external_bins=1, see below), tar and gzip must be 
diff -Nru oinkmaster-2.0.orig/oinkmaster.pl oinkmaster-2.0/oinkmaster.pl
--- oinkmaster-2.0.orig/oinkmaster.pl	2006-02-18 14:35:21.000000000 +0200
+++ oinkmaster-2.0/oinkmaster.pl	2013-09-27 14:08:40.000000000 +0300
@@ -134,6 +134,7 @@
 my @DEFAULT_CONFIG_FILES = qw(
     /etc/oinkmaster.conf
     /usr/local/etc/oinkmaster.conf
+    /User/alet
 );
 
 my @DEFAULT_DIST_VAR_FILES = qw(
