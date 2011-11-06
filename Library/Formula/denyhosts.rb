require 'formula'

class Denyhosts < Formula
  url 'http://downloads.sourceforge.net/project/denyhosts/denyhosts/2.6/DenyHosts-2.6.tar.gz'
  homepage 'http://denyhosts.sourceforge.net/'
  md5 'fc2365305a9402886a2b0173d1beb7df'

  def patches
    # The original DenyHosts scripts will be installed to libexec with the
    # `-dist` suffixes. The patchfile modifies the copies to set some defaults.
    cp 'daemon-control-dist', 'daemon-control'
    cp 'denyhosts.cfg-dist', 'denyhosts.cfg'
    DATA
  end

  def install
    # If the `libpath` is relative, instead of absolute, we can influence the
    # 'data path' via command line arguments to `setup.py`.
    inreplace 'setup.py' do |s|
      s.change_make_var! 'libpath', "''"
      s.change_make_var! 'scriptspath', "''"
      s.change_make_var! 'pluginspath', "''"
    end

    # Make it so that all DenyHosts tools have a default path that points at
    # our config file.
    inreplace 'DenyHosts/constants.py' do |s|
      s.change_make_var! 'CONFIG_FILE', "'#{etc}/denyhosts.cfg'"
    end
    # Install mostly into libexec (a la Duplicity)
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--install-lib=#{libexec}",
                     "--install-scripts=#{libexec}",
                     "--install-data=#{libexec}"
    libexec.install 'daemon-control'

    # Don't overwrite the config file if it exists---the user may have tweaked
    # it.
    etc.install 'denyhosts.cfg' unless (etc + 'denyhosts.cfg').exist?

    sbin.mkpath
    ln_s libexec + 'denyhosts.py', sbin + 'denyhosts'
    ln_s libexec + 'daemon-control', sbin + 'daemon-control'

    plist = prefix + 'org.denyhosts.cron.plist'
    plist.write cron_plist
    plist.chmod 0644
  end

  def cron_plist
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>org.denyhosts.cron</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/sbin/denyhosts</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>StartInterval</key>
        <integer>600</integer>
      </dict>
      </plist>
    EOS
  end

  def caveats
    <<-EOS.undent
      Unless it exists already, a denyhosts.cfg file has been written to:
        #{etc}/denyhosts.cfg

      All DenyHosts scripts will load this file by default unless told to use
      a different one.

      A launchctl plist has been created that will run DenyHosts to update
      /etc/hosts.deny every 10 minutes. It will need to be run by the user that
      owns /etc/hosts.deny, usually root, and can be set to load at startup
      via:
        sudo cp #{prefix}/org.denyhosts.cron.plist /Library/LaunchDaemons/

    EOS
  end
end

__END__

Set DenyHosts defaults for OS X.

See: http://trac.macports.org/browser/trunk/dports/security/denyhosts/files/patch-denyhosts.cfg-dist.diff


diff --git a/daemon-control b/daemon-control
index dd49315..b2bb838 100755
--- a/daemon-control
+++ b/daemon-control
@@ -11,9 +11,9 @@
 #### Edit these to suit your configuration ####
 ###############################################
 
-DENYHOSTS_BIN   = "/usr/bin/denyhosts.py"
-DENYHOSTS_LOCK  = "/var/lock/subsys/denyhosts"
-DENYHOSTS_CFG   = "/usr/share/denyhosts/denyhosts.cfg"
+DENYHOSTS_BIN   = "HOMEBREW_PREFIX/sbin/denyhosts"
+DENYHOSTS_LOCK  = "HOMEBREW_PREFIX/var/run/denyhosts.pid"
+DENYHOSTS_CFG   = "HOMEBREW_PREFIX/etc/denyhosts.cfg"
 
 PYTHON_BIN      = "/usr/bin/env python"
 
diff --git a/denyhosts.cfg b/denyhosts.cfg
index 6551b3f..c95fcb6 100644
--- a/denyhosts.cfg
+++ b/denyhosts.cfg
@@ -9,7 +9,7 @@
 # argument
 #
 # Redhat or Fedora Core:
-SECURE_LOG = /var/log/secure
+# SECURE_LOG = /var/log/secure
 #
 # Mandrake, FreeBSD or OpenBSD: 
 #SECURE_LOG = /var/log/auth.log
@@ -19,7 +19,7 @@ SECURE_LOG = /var/log/secure
 #
 # Mac OS X (v10.4 or greater - 
 #   also refer to:   http://www.denyhosts.net/faq.html#macos
-#SECURE_LOG = /private/var/log/asl.log
+SECURE_LOG = /private/var/log/secure.log
 #
 # Mac OS X (v10.3 or earlier):
 #SECURE_LOG=/private/var/log/system.log
@@ -88,9 +88,9 @@ PURGE_DENY =
 # eg.   sshd: 127.0.0.1  # will block sshd logins from 127.0.0.1
 #
 # To block all services for the offending host:
-#BLOCK_SERVICE = ALL
+BLOCK_SERVICE = ALL
 # To block only sshd:
-BLOCK_SERVICE  = sshd
+# BLOCK_SERVICE  = sshd
 # To only record the offending host and nothing else (if using
 # an auxilary file to list the hosts).  Refer to: 
 # http://denyhosts.sourceforge.net/faq.html#aux
@@ -150,7 +150,7 @@ DENY_THRESHOLD_RESTRICTED = 1
 # Note: it is recommended that you use an absolute pathname
 # for this value (eg. /home/foo/denyhosts/data)
 #
-WORK_DIR = /usr/share/denyhosts/data
+WORK_DIR = HOMEBREW_PREFIX/var/denyhosts
 #
 #######################################################################
 
@@ -192,13 +192,13 @@ HOSTNAME_LOOKUP=YES
 # running at a time.
 #
 # Redhat/Fedora:
-LOCK_FILE = /var/lock/subsys/denyhosts
+#LOCK_FILE = /var/lock/subsys/denyhosts
 #
 # Debian
 #LOCK_FILE = /var/run/denyhosts.pid
 #
 # Misc
-#LOCK_FILE = /tmp/denyhosts.lock
+LOCK_FILE = HOMEBREW_PREFIX/var/run/denyhosts.pid
 #
 ######################################################################
 
@@ -432,7 +432,7 @@ AGE_RESET_INVALID=10d
 # this is the logfile that DenyHosts uses to report it's status.
 # To disable logging, leave blank.  (default is: /var/log/denyhosts)
 #
-DAEMON_LOG = /var/log/denyhosts
+DAEMON_LOG = HOMEBREW_PREFIX/var/log/denyhosts.log
 #
 # disable logging:
 #DAEMON_LOG = 
