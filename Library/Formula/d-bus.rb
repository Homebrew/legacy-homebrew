require "formula"

class DBus < Formula
  homepage "http://www.freedesktop.org/wiki/Software/dbus"
  url "http://dbus.freedesktop.org/releases/dbus/dbus-1.8.8.tar.gz"
  sha1 "e0d10e8b4494383c7e366ac80a942ba45a705a96"

  bottle do
    revision 1
    sha1 "6258f4a3816c909fe3ef9aa9da7b596c56471d1e" => :yosemite
    sha1 "de9cc0897fadf951d0a915263ec8303ce3f27e23" => :mavericks
    sha1 "6132e9f82c522fef668c31319bd8c03ae42dfcda" => :mountain_lion
  end

  # Upstream fix for O_CLOEXEC portability
  # http://cgit.freedesktop.org/dbus/dbus/commit/?id=5d91f615d18629eaac074fbde2ee7e17b82e5472
  patch do
    url "http://cgit.freedesktop.org/dbus/dbus/patch/?id=5d91f615d18629eaac074fbde2ee7e17b82e5472"
    sha1 "ebb383abb86eeafbe048dbb8b77d83bdf0b7c9bb"
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
                          "--without-x",
                          "--disable-tests"
    system "make"
    ENV.deparallelize
    system "make install"

    (prefix+"org.freedesktop.dbus-session.plist").chmod 0644
  end

  def post_install
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
