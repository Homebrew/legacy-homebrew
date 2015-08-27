class DBus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"

  stable do
    url "http://dbus.freedesktop.org/releases/dbus/dbus-1.10.0.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/d/dbus/dbus_1.10.0.orig.tar.gz"
    sha256 "1dfb9745fb992f1ccd43c920490de8caddf6726a6222e8b803be6098293f924b"
  end

  bottle do
    sha256 "ea3d2959691805ffcf1e7e617cf2313cd5b1acc39af73592a0abfedf5c508508" => :yosemite
    sha256 "e435021d0865d78a1f9596deccbb8ea0d8214e8a9fbd125c3463e9f37b3b930d" => :mavericks
    sha256 "a5db4a301a2053bc7b264b63e0d1062e4285c97d01d5dc69df87c30556866ba0" => :mountain_lion
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
