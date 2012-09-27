require 'formula'

class IrcdHybrid < Formula
  homepage 'http://www.ircd-hybrid.org/'
  url 'http://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-7.3.1/ircd-hybrid-7.3.1.tgz'
  sha1 'a4d7e06517152ea88b064cd9756084372ed831ac'

  # ircd-hybrid needs the .la files
  skip_clean 'lib'

  def install
    # See patch fix 3
    mv 'etc/example.conf', 'etc/ircd.conf'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          # there's no config setting for this so set it to something generous
                          "--with-nicklen=30"
    system "make install"
  end

  def test
    system "ircd -version"
  end

  # Fix 1: Set an sid so it runs
  # Fix 2: Remove the trap line so it runs
  # Fix 3: Rename config path in Makefile to match where we moved it
  def patches
    DATA
  end

  def caveats; <<-EOS.undent
    You'll more than likely need to edit the default settings in the config file:
      #{etc}/ircd.conf

    If this is your first install, automatically load on login with:
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
      launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Or start manually with:
      ircd

    Which will give you a pid you can kill with:
      kill pid
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>KeepAlive</key>
  <false/>
  <key>Label</key>
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{HOMEBREW_PREFIX}/sbin/ircd</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>UserName</key>
  <string>#{`whoami`.chomp}</string>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
  <key>StandardErrorPath</key>
  <string>#{var}/ircd.log</string>
</dict>
</plist>
    EOPLIST
  end
end


__END__
diff --git a/etc/example.conf b/etc/example.conf
index d74ef84..94d2218 100644
--- a/etc/example.conf
+++ b/etc/example.conf
@@ -53,7 +53,7 @@ serverinfo {
	 * a digit, followed by 2 alpha-numerical letters.
	 * NOTE: The letters must be capitalized.  This cannot be changed at runtime.
	 */
-	sid = "_CHANGE_ME_";
+	sid = "1AA";

	/*
	 * description: the description of the server.  '[' and ']' may not
@@ -1144,7 +1144,7 @@ general {
	idletime = 0;

	/* REMOVE ME.  The following line checks you've been reading. */
-	havent_read_conf = 1;
+	/* havent_read_conf = 1; */

	/*
	 * max_targets: the maximum amount of targets in a single
diff --git a/etc/Makefile.am b/etc/Makefile.am
index ac0ac33..9a93ee2 100644
--- a/etc/Makefile.am
+++ b/etc/Makefile.am
@@ -2,5 +2,5 @@ AUTOMAKE_OPTIONS = foreign
 if EFNET
 dist_sysconf_DATA = example.efnet.conf
 else
-dist_sysconf_DATA = example.conf
+dist_sysconf_DATA = ircd.conf
 endif
diff --git a/etc/Makefile.in b/etc/Makefile.in
index dd88824..60d9b19 100644
--- a/etc/Makefile.in
+++ b/etc/Makefile.in
@@ -48,7 +48,7 @@ CONFIG_CLEAN_FILES =
 CONFIG_CLEAN_VPATH_FILES =
 SOURCES =
 DIST_SOURCES =
-am__dist_sysconf_DATA_DIST = example.conf example.efnet.conf
+am__dist_sysconf_DATA_DIST = ircd.conf example.efnet.conf
 am__vpath_adj_setup = srcdirstrip=`echo "$(srcdir)" | sed 's|.|.|g'`;
 am__vpath_adj = case $$p in \
     $(srcdir)/*) f=`echo "$$p" | sed "s|^$$srcdirstrip/||"`;; \
@@ -214,7 +214,7 @@ top_build_prefix = @top_build_prefix@
 top_builddir = @top_builddir@
 top_srcdir = @top_srcdir@
 AUTOMAKE_OPTIONS = foreign
-@EFNET_FALSE@dist_sysconf_DATA = example.conf
+@EFNET_FALSE@dist_sysconf_DATA = ircd.conf
 @EFNET_TRUE@dist_sysconf_DATA = example.efnet.conf
 all: all-am
