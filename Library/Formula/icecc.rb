require 'formula'

class Icecc < Formula
  url 'ftp://ftp.suse.com/pub/projects/icecream/icecc-0.9.7.tar.bz2'
  homepage 'http://en.opensuse.org/Icecream'
  md5 'c06900c2f4011428d0d48826a04f74fb'
  version '0.9.7'

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    (prefix+'org.opensuse.icecc.plist').write iceccd_plist
    (prefix+'org.opensuse.icecc-scheduler.plist').write scheduler_plist
  end

  def caveats
    return <<-EOS
To override the toolset with icecc, add to your path:
   #{prefix}/bin/icecc-toolset

To setup the icecc daemon:
    cp #{prefix}/org.opensuse.icecc.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.opensuse.icecc.plist

To setup the icecc scheduler:
    cp #{prefix}/org.opensuse.icecc-scheduler.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.opensuse.icecc-scheduler.plist

If this is an upgrade, to restart a previous setup of the icecc daemon or scheduler:
    launchctl unload -w ~/Library/LaunchAgents/org.openuses.icecc.plist
    launchctl load -w ~/Library/LaunchAgents/org.openuses.icecc.plist
 or
    launchctl unload -w ~/Library/LaunchAgents/org.openuses.icecc-scheduler.plist
    launchctl load -w ~/Library/LaunchAgents/org.openuses.icecc-scheduler.plist
EOS
  end

  def iceccd_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>Icecc Daemon</string>
    <key>ProgramArguments</key>
    <array>
    <string>#{sbin}/iceccd</string>
    <string>-d</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOS
  end

  def scheduler_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>Icecc Scheduler</string>
    <key>ProgramArguments</key>
    <array>
    <string>#{sbin}/scheduler</string>
    <string>-d</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOS
  end
end
__END__
diff --git a/client/Makefile.in b/client/Makefile.in
index 187d695..199c739 100644
--- a/client/Makefile.in
+++ b/client/Makefile.in
@@ -614,11 +614,12 @@ uninstall-am: uninstall-binPROGRAMS uninstall-local \
 
 
 install-exec-local:
-	$(mkinstalldirs) $(DESTDIR)$(bindir)
-	for link in g++ gcc c++ cc icerun; do \
-	  rm -f $(DESTDIR)$(bindir)/$$link ;\
-	  $(LN_S) icecc $(DESTDIR)$(bindir)/$$link ;\
-	done
+	$(mkinstalldirs) $(DESTDIR)$(bindir) $(DESTDIR)$(bindir)/icecc-toolset
+	for link in g++ gcc c++ cc; do \
+	  rm -f $(DESTDIR)$(bindir)/icecc-toolset/$$link ;\
+	  $(LN_S) ../icecc $(DESTDIR)$(bindir)/icecc-toolset/$$link ;\
+	done ;\
+	$(LN_S) icecc $(DESTDIR)$(bindir)/icerun
 
 uninstall-local:
 	for link in g++ gcc c++ cc; do \
