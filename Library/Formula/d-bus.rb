require 'formula'

class DBus <Formula
  url 'http://dbus.freedesktop.org/releases/dbus/dbus-1.4.0.tar.gz'
  homepage 'http://www.freedesktop.org/wiki/Software/dbus'
  md5 'f59618b18d2fb2bd1fce9e1c5a2a3282'

  # Don't clean the empty directories that D-Bus needs
  skip_clean "etc/dbus-1/session.d"
  skip_clean "etc/dbus-1/system.d"
  skip_clean "var/run/dbus"

  def patches
    # Patches merged upstream for launchd support.
    # See http://bugs.freedesktop.org/show_bug.cgi?id=14259
    [ 'http://cgit.freedesktop.org/dbus/dbus/patch/?id=5125fc165454e81849a5b20c1e75b4f74bdbcd2c',
      'http://cgit.freedesktop.org/dbus/dbus/patch/?id=eb66c0a9c001ea08793b38470d12611ffaafa436',
      'http://cgit.freedesktop.org/dbus/dbus/patch/?id=f1b9aac417d8fb716d6ed19128fe429e8a41adba' ]
  end

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"

    # Needed to regenerate configure for the patches to work
    system "autoreconf -ivf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-xml-docs",
                          "--disable-doxygen-docs",
                          "--enable-launchd",
                          "--with-launchd-agent-dir=#{prefix}",
                          "--without-x"
    system "make install"

    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{prefix}/var/lib/dbus/machine-id"
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
        cp #{prefix}/org.freedesktop.dbus-session.plist ~/Library/LaunchAgents
        launchctl load -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist

    If this is an upgrade and you already have the org.freedesktop.dbus-session.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist
        cp #{prefix}/org.freedesktop.dbus-session.plist ~/Library/LaunchAgents
        launchctl load -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist
    EOS
  end
end
