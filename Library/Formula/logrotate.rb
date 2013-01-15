require 'formula'

class Logrotate < Formula
  homepage 'http://packages.debian.org/testing/admin/logrotate'
  url 'https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.8.3.tar.gz'
  sha1 '19d70e2cfb97c1cee32e0d709da990856311022a'

  depends_on 'popt'

  # Per MacPorts, let these variables be overridden by ENV vars.
  # Also, use HOMEBREW suggested locations for run and log files.
  def patches
    DATA
  end

  def install
    # Otherwise defaults to /bin/gz
    ENV["COMPRESS_COMMAND"] = "/usr/bin/gzip"
    ENV["COMPRESS_EXT"] = ".gz"
    ENV["UNCOMPRESS_COMMAND"] = "/usr/bin/gunzip"
    ENV["STATEFILE"] = "#{var}/lib/logrotate.status"

    system "make"
    sbin.install 'logrotate'
    man8.install 'logrotate.8'
    man5.install 'logrotate.conf.5'

    mv "examples/logrotate-default", "logrotate.conf"
    inreplace "logrotate.conf" do |s|
      s.gsub! "/etc/logrotate.d", "#{etc}/logrotate.d"
    end

    etc.install 'logrotate.conf' unless (etc/'logrotate.conf').exist?
    (etc/'logrotate.d').mkpath
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/logrotate</string>
          <string>#{etc}/logrotate.conf</string>
        </array>
        <key>RunAtLoad</key>
        <false/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>StartCalendarInterval</key>
        <dict>
          <key>Hour</key>
          <integer>6</integer>
          <key>Minute</key>
          <integer>25</integer>
        </dict>
      </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/Makefile b/Makefile
index d65a3f3..14d1f3f 100644
--- a/Makefile
+++ b/Makefile
@@ -76,6 +76,22 @@ ifneq ($(POPT_DIR),)
     LOADLIBES += -L$(POPT_DIR)
 endif
 
+ifneq ($(COMPRESS_COMMAND),)
+    CFLAGS += -DCOMPRESS_COMMAND=\"$(COMPRESS_COMMAND)\"
+endif
+
+ifneq ($(COMPRESS_EXT),)
+    CFLAGS += -DCOMPRESS_EXT=\"$(COMPRESS_EXT)\"
+endif
+
+ifneq ($(UNCOMPRESS_COMMAND),)
+    CFLAGS += -DUNCOMPRESS_COMMAND=\"$(UNCOMPRESS_COMMAND)\"
+endif
+
+ifneq ($(DEFAULT_MAIL_COMMAND),)
+    CFLAGS += -DDEFAULT_MAIL_COMMAND=\"$(DEFAULT_MAIL_COMMAND)\"
+endif
+
 ifneq ($(STATEFILE),)
     CFLAGS += -DSTATEFILE=\"$(STATEFILE)\"
 endif

diff --git a/examples/logrotate-default b/examples/logrotate-default
index 7da6bb7..0b27baf 100644
--- a/examples/logrotate-default
+++ b/examples/logrotate-default
@@ -14,22 +14,5 @@ dateext
 # uncomment this if you want your log files compressed
 #compress

-# RPM packages drop log rotation information into this directory
+# homebrew packages drop log rotation information into this directory
 include /etc/logrotate.d
-
-# no packages own wtmp and btmp -- we'll rotate them here
-/var/log/wtmp {
-    monthly
-    create 0664 root utmp
-	minsize 1M
-    rotate 1
-}
-
-/var/log/btmp {
-    missingok
-    monthly
-    create 0600 root utmp
-    rotate 1
-}
-
-# system-specific logs may be also be configured here.
