class DBus < Formula
  # releases: even (1.8.x) = stable, odd (1.9.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"

  stable do
    url "http://dbus.freedesktop.org/releases/dbus/dbus-1.8.20.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/d/dbus/dbus_1.8.20.orig.tar.gz"
    sha256 "5c4fbf4c64621c96e871da91d2b729a5b00536e116d3c4612a469d924b1b703a"

    # Upstream fix for O_CLOEXEC portability
    # http://cgit.freedesktop.org/dbus/dbus/commit/?id=5d91f615d18629eaac074fbde2ee7e17b82e5472
    # This is fixed in 1.9.x but won't be fixed upstream for 1.8.x
    patch do
      url "http://cgit.freedesktop.org/dbus/dbus/patch/?id=5d91f615d18629eaac074fbde2ee7e17b82e5472"
      sha256 "35a021c54da36b22d720acc23f5f133a609cb268e7cb16e36a772552e9cf3e69"
    end
  end

  bottle do
    sha256 "ea3d2959691805ffcf1e7e617cf2313cd5b1acc39af73592a0abfedf5c508508" => :yosemite
    sha256 "e435021d0865d78a1f9596deccbb8ea0d8214e8a9fbd125c3463e9f37b3b930d" => :mavericks
    sha256 "a5db4a301a2053bc7b264b63e0d1062e4285c97d01d5dc69df87c30556866ba0" => :mountain_lion
  end

  devel do
    url "http://dbus.freedesktop.org/releases/dbus/dbus-1.9.20.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/d/dbus/dbus_1.9.20.orig.tar.gz"
    sha256 "eca888e325c32c01fd9494d418b8b4550b8c71d05e1d977a195ed193108ae700"
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
