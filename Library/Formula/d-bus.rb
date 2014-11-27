require "formula"

class DBus < Formula
  # releases: even (1.8.x) = stable, odd (1.9.x) = development
  homepage "http://www.freedesktop.org/wiki/Software/dbus"
  url "http://dbus.freedesktop.org/releases/dbus/dbus-1.8.12.tar.gz"
  sha1 "9dc3003a53892b41eb61ade20051aba57be1b4b1"

  bottle do
    sha1 "50c1012cd5f5b89f2f5a843fb9de22bc76dc5178" => :yosemite
    sha1 "825bfc579a58d923697893d70fb2b9af157a9a77" => :mavericks
    sha1 "5b53fa3634d6aaec601b0b5a1c6330392b240958" => :mountain_lion
  end

  # Upstream fix for O_CLOEXEC portability
  # http://cgit.freedesktop.org/dbus/dbus/commit/?id=5d91f615d18629eaac074fbde2ee7e17b82e5472
  # This is fixed in 1.9.x but won't be fixed upstream for 1.8.x
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
    system "make", "install"

    (prefix+"org.freedesktop.dbus-session.plist").chmod 0644
  end

  def post_install
    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  test do
    system "#{bin}/dbus-daemon", "--version"
  end
end
