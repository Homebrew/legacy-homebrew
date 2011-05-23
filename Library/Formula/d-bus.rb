require 'formula'

class DBus < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/dbus'
  url 'http://dbus.freedesktop.org/releases/dbus/dbus-1.4.8.tar.gz'
  sha256 '48bf73a35be0f0e2d9a5071d8f2d9c7c40b4254d9b405dee57f0fb07c9c3cf58'

  # Don't clean the empty directories that D-Bus needs
  skip_clean "etc/dbus-1/session.d"
  skip_clean "etc/dbus-1/system.d"
  skip_clean "var/run/dbus"

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
