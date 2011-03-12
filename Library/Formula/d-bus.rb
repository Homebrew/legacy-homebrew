require 'formula'

class DBus <Formula
  url 'http://dbus.freedesktop.org/releases/dbus/dbus-1.4.1.tar.gz'
  homepage 'http://www.freedesktop.org/wiki/Software/dbus'
  md5 '99cb057700c0455fb68f8d57902f77ac'

  # Don't clean the empty directories that D-Bus needs
  skip_clean "etc/dbus-1/session.d"
  skip_clean "etc/dbus-1/system.d"
  skip_clean "var/run/dbus"

  def patches
    # Last-minute build breakages for 1.4.1
    [ 'http://cgit.freedesktop.org/dbus/dbus/patch/?id=88004d6b66f80d72e97e9b6b024842d692e5748a',
      'http://cgit.freedesktop.org/dbus/dbus/patch/?id=56d8d4f58ee60cd4f860a99a2dd47b3f636321b8' ]
  end

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"


    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-xml-docs",
                          "--disable-doxygen-docs",
                          "--enable-launchd",
                          "--with-launchd-agent-dir=#{prefix}",
                          "--without-x"
    system "make"
    ENV.deparallelize
    system "make install"

    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{prefix}/var/lib/dbus/machine-id"
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
