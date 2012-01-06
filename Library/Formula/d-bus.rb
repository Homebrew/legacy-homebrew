require 'formula'

class DBus < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/dbus'
  url 'http://dbus.freedesktop.org/releases/dbus/dbus-1.4.16.tar.gz'
  sha256 '1d8ee6262f8cc2148f06578eee522c755ba0896206b3464ca9bdc84f411b29c6'

  # man2html needs to be piped the input instead of given a filename. See:
  # http://forums.freebsd.org/archive/index.php/t-20529.html
  # https://github.com/mxcl/homebrew/issues/8978
  # https://bugs.freedesktop.org/show_bug.cgi?id=43875
  # Otherwise, if man2html is installed the build will hang.
  def patches
    DATA
  end

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--disable-xml-docs",
                          "--disable-doxygen-docs",
                          "--enable-launchd",
                          "--with-launchd-agent-dir=#{prefix}",
                          "--without-x"
    system "make"
    ENV.deparallelize
    system "make install"

    (prefix+'org.freedesktop.dbus-session.plist').chmod 0644

    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.freedesktop.dbus-session.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist

    If this is an upgrade and you already have the org.freedesktop.dbus-session.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist
        cp #{prefix}/org.freedesktop.dbus-session.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist
    EOS
  end
end

__END__
diff --git a/doc/Makefile.in b/doc/Makefile.in
index 45e1062..d79c018 100644
--- a/doc/Makefile.in
+++ b/doc/Makefile.in
@@ -728,7 +728,7 @@ uninstall-man: uninstall-man1
 @DBUS_DOXYGEN_DOCS_ENABLED_TRUE@		rmdir $(DESTDIR)$(apidir)
 
 @DBUS_HAVE_MAN2HTML_TRUE@%.1.html: %.1
-@DBUS_HAVE_MAN2HTML_TRUE@	$(AM_V_GEN)( $(MAN2HTML) $< > $@.tmp && mv $@.tmp $@ )
+@DBUS_HAVE_MAN2HTML_TRUE@	$(AM_V_GEN)( $(MAN2HTML) < $< > $@.tmp && mv $@.tmp $@ )
 
 @DBUS_CAN_UPLOAD_DOCS_TRUE@dbus-docs: $(STATIC_DOCS) $(dist_doc_DATA) $(dist_html_DATA) $(MAN_HTML_FILES) $(BONUS_FILES) doxygen.stamp
 @DBUS_CAN_UPLOAD_DOCS_TRUE@	$(AM_V_at)rm -rf $@ $@.tmp
