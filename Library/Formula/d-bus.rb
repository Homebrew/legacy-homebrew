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
    sha256 "68500e3670555c2bf5eaeae7541111f9052e92c4a7b28410a0ded25fd7cac544" => :el_capitan
    sha256 "5a49bcf55334b90e3cd6725b7cc6f0383bcf0160ca7a8d12611107ac7f6a022a" => :yosemite
    sha256 "a2b9e6c8e84a6e199dcd22d748b3c617285a1eba4ec0b042fa16e9171e96bd91" => :mavericks
    sha256 "8f571788a6bd6209e27b4e4cbdd4e1d2179b7f3bbdb35262c3159ff28336b76a" => :mountain_lion
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
