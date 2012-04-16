require 'formula'

class Anacron < Formula
  homepage 'http://sourceforge.net/projects/anacron/'
  url 'http://downloads.sourceforge.net/project/anacron/anacron/2.3/anacron-2.3.tar.gz'
  md5 '865cc1dfe1ed75c470d3e6de13763f03'


  def install
    args = ["PREFIX=#{prefix}",
            "MANDIR=#{man}",
            "BINDIR=#{sbin}",
            "SPOOLDIR=#{HOMEBREW_PREFIX}/var/spool/anacron",
            "ANACRONTAB=#{HOMEBREW_PREFIX}/etc/anacrontab"]

    system "make", *args
    system "make", "install", *args

    plist_path.write cron_plist
    plist_path.chmod 0644
  end

  def patches
    [
        'https://gist.github.com/raw/2376077/a34102461aa5bf55edc2d1cd98ffefdae18c9bec/fix-const-isleap-error.diff',
        'https://gist.github.com/raw/2376042/224e16bc270b6c39f335d8f901e8ec1dc2f334bd/add-obstack-source.diff',
        DATA
    ]
  end

  def cron_plist
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/sbin/anacron</string>
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
      Unless it exists already, a anacrontab file has been written to:
        #{etc}/anacrontab

      Here is example:

        SHELL=/bin/sh
        PATH=#{HOMEBREW_PREFIX}/sbin:#{HOMEBREW_PREFIX}/bin:/sbin:/bin:/usr/sbin:/usr/bin
        # format: period delay job-identifier command
        1       5       cron.daily      run-parts /etc/cron.daily
        7       10      cron.weekly     run-parts /etc/cron.weekly
        30      15      cron.monthly    run-parts /etc/cron.monthly

      A launchctl plist has been created that will run anacron every 10 minutes.
      It can be set to load at startup via:
        sudo cp #{plist_path} /Library/LaunchDaemons/
        launchctl load -w /Library/LaunchDaemons/#{plist_path.basename}

    EOS
  end
end

__END__
diff --git a/Makefile b/Makefile
index 81dcc15..52bd115 100644
--- a/Makefile
+++ b/Makefile
@@ -64,7 +64,7 @@ anacron: $(objects)
 
 .PHONY: installdirs
 installdirs:
-	$(INSTALL_DIR) $(BINDIR) $(PREFIX)$(SPOOLDIR) \
+	$(INSTALL_DIR) $(BINDIR) $(SPOOLDIR) \
 		$(MANDIR)/man5 $(MANDIR)/man8
 
 .PHONY: install
diff --git a/anacron.8 b/anacron.8
index a3561be..d55fbc6 100644
--- a/anacron.8
+++ b/anacron.8
@@ -18,7 +18,7 @@ to control daily, weekly, and monthly jobs that are
 usually controlled by \fBcron\fR.
 .PP
 When executed, Anacron reads a list of jobs from a configuration file, normally
-.I /etc/anacrontab
+.I HOMEBREW_PREFIX/etc/anacrontab
 (see \fBanacrontab(5)\fR).  This file
 contains the list of jobs that Anacron controls.  Each
 job entry specifies a period in days, 
@@ -84,7 +84,7 @@ previous one finished.
 .TP
 .B -n
 Run jobs now.  Ignore the delay specifications in the
-.I /etc/anacrontab
+.I HOMEBREW_PREFIX/etc/anacrontab
 file.  This options implies \fB-s\fR.
 .TP
 .B -d
@@ -117,11 +117,11 @@ file.  See
 for more information.
 .SH FILES
 .TP
-.I /etc/anacrontab
+.I HOMEBREW_PREFIX/etc/anacrontab
 Contains specifications of jobs.  See \fBanacrontab(5)\fR for a complete
 description.
 .TP
-.I /var/spool/anacron
+.I HOMEBREW_PREFIX/var/spool/anacron
 This directory is used by Anacron for storing timestamp files.
 .SH "SEE ALSO"
 .B anacrontab(5), cron(8), tzset(3)
diff --git a/anacrontab.5 b/anacrontab.5
index 93a67a0..d73f46e 100644
--- a/anacrontab.5
+++ b/anacrontab.5
@@ -1,9 +1,9 @@
 .TH ANACRONTAB 5 1998-02-02 "Itai Tzur" "Anacron Users' Manual"
 .SH NAME
-/etc/anacrontab \- configuration file for anacron
+HOMEBREW_PREFIX/etc/anacrontab \- configuration file for anacron
 .SH DESCRIPTION
 The file
-.I /etc/anacrontab
+.I HOMEBREW_PREFIX/etc/anacrontab
 describes the jobs controlled by \fBanacron(8)\fR.  Its lines can be of
 three kinds:  job-description lines, environment
 assignments, or empty lines.

