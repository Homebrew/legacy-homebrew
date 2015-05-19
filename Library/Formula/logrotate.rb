class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://fedorahosted.org/logrotate/"
  url "https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.9.1.tar.gz"
  sha256 "022769e3288c80981559a8421703c88e8438b447235e36dd3c8e97cd94c52545"

  bottle do
    cellar :any
    sha256 "54e30ff0979a6840433942dca543ae3369f7850db3ebf309aa4e1ef47d7fe744" => :yosemite
    sha256 "bd8a9901a24bb1a72e05a6e5dd5359d0ab609cc7fd6b48654ba5dfca0d7ada42" => :mavericks
    sha256 "ab15e12cf49a7bb508227685c404c586705497bf3fbf2a7d37f18e3476121d2b" => :mountain_lion
  end

  depends_on "popt"

  # Per MacPorts, let these variables be overridden by ENV vars.
  # Also, use HOMEBREW suggested locations for run and log files.
  patch :DATA

  def install
    # Otherwise defaults to /bin/gz
    ENV["COMPRESS_COMMAND"] = "/usr/bin/gzip"
    ENV["COMPRESS_EXT"] = ".gz"
    ENV["UNCOMPRESS_COMMAND"] = "/usr/bin/gunzip"
    ENV["STATEFILE"] = "#{var}/lib/logrotate.status"

    system "make"
    sbin.install "logrotate"
    man8.install "logrotate.8"
    man5.install "logrotate.conf.5"

    mv "examples/logrotate-default", "logrotate.conf"
    inreplace "logrotate.conf" do |s|
      s.gsub! "/etc/logrotate.d", "#{etc}/logrotate.d"
    end

    etc.install "logrotate.conf"
    (etc/"logrotate.d").mkpath
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
diff --git i/Makefile w/Makefile
index 5a42fb6..e53f4f7 100644
--- i/Makefile
+++ w/Makefile
@@ -86,6 +86,22 @@ ifneq ($(POPT_DIR),)
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
diff --git i/examples/logrotate-default w/examples/logrotate-default
index 56e9103..c61a33a 100644
--- i/examples/logrotate-default
+++ w/examples/logrotate-default
@@ -14,22 +14,7 @@ dateext
 # uncomment this if you want your log files compressed
 #compress
 
-# RPM packages drop log rotation information into this directory
+# Homebrew packages drop log rotation information into this directory
 include /etc/logrotate.d
 
-# no packages own wtmp and btmp -- we'll rotate them here
-/var/log/wtmp {
-    monthly
-    create 0664 root utmp
-    minsize 1M
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
 # system-specific logs may be also be configured here.
