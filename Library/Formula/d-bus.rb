require 'brewkit'

class DBus <Formula
  url 'http://dbus.freedesktop.org/releases/dbus/dbus-1.2.16.tar.gz'
  homepage 'http://www.freedesktop.org/wiki/Software/dbus'
  md5 'c7a47b851ebe02f6726b65b78d1b730b'

  def patches
    'http://gist.github.com/raw/201422/a53c062bc9e1396138de9f0bbddcba31de441d16/dbus-launchd-integration-1.2.16.patch'
  end

  def install
    system "autoreconf -fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-doxygen-docs",
                          "--disable-xml-docs",
                          "--without-x",
                          "--enable-launchd",
                          "--with-dbus-user=messagebus",
                          "--with-launchd-agent-dir=#{prefix}/Library/LaunchAgents",
                          "--with-dbus-daemondir=#{bin}"

    inreplace "dbus/dbus-sysdeps-unix.c", "/usr/local", "#{prefix}"
    inreplace "configure", "broken_poll=\"no (cross compiling)\"", "broken_poll=yes"
    # don't want /g, so call it ourselves

    system "make install"

    (etc + "dbus-1" + "session.d").mkpath
    (prefix + "Library" + "LaunchDaemons" + "org.freedesktop.dbus-system.plist").write plist
  end

  def plist; <<-EOS
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version='1.0'>
<dict>
  <key>Label</key>
  <string>org.freedesktop.dbus-system</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/dbus-daemon</string>
    <string>--system</string>
    <string>--nofork</string>
  </array>
  <key>OnDemand</key>
  <false/>
  <key>Disabled</key>
  <true/>
</dict>
</plist>
    EOS
  end
  
  def caveats; <<-EOS
The dbus system bus can auto-start with OS X, but it requires a symlink in
your system library dir. Run the next two commands to hook things up:

    sudo ln -s #{prefix}/Library/LaunchAgents/org.freedesktop.dbus-session.plist /Library/LaunchAgents/org.freedesktop.dbus-session.plist
    sudo ln -s #{prefix}/Library/LaunchDaemons/org.freedesktop.dbus-system.plist /Library/LaunchDaemons/org.freedesktop.dbus-system.plist

You will also need to make the two launchd files owned by root, otherwise OS X
will complain:

    sudo chown root:admin #{prefix}/Library/LaunchAgents/org.freedesktop.dbus-session.plist
    sudo chown root:admin #{prefix}/Library/LaunchDaemons/org.freedesktop.dbus-system.plist

Note that you will have to change them back to a user ownership, as well as
remove the symlinks when uninstalling, as homebrew won't be able to erase
them.

If you want dbus to auto-start, run the following two commands:

    sudo launchctl load -w /Library/LaunchDaemons/org.freedesktop.dbus-system.plist
    launchctl load /Library/LaunchAgents/org.freedesktop.dbus-session.plist

Then it will autostart when needed from the next reboot.

Also, if programs are having trouble connecting to the dbus session, add this
to your /etc/profile:

    export DBUS_SESSION_BUS_ADDRESS="launchd:env=DBUS_LAUNCHD_SESSION_BUS_SOCKET" 
    EOS
  end
end
