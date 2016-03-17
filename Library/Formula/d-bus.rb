class DBus < Formula
  # releases: even (1.10.x) = stable, odd (1.11.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.10.6.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dbus/dbus_1.10.6.orig.tar.gz"
  master "git://anongit.freedesktop.org/dbus/dbus.git"
  sha256 "b5fefa08a77edd76cd64d872db949eebc02cf6f3f8be82e4bbc641742af5d35f"

  bottle do
    sha256 "edf31f467954d3ead8d32fe9db3ef406211fa03eba81b2ab9cad842359a76829" => :el_capitan
    sha256 "e1818ef166c0d49071bd687e83ec51367052bb8846888a482cac823a991aa092" => :yosemite
    sha256 "08094b506bf81ce24aa9c38d9414b43726b35d19461440ecfc74d47d02298d50" => :mavericks
  end

  # Patches apply the config templating fixed in https://bugs.freedesktop.org/show_bug.cgi?id=94494
  if MacOS.version >= :leopard
    patch do
      url "https://raw.githubusercontent.com/zbentley/dbus-osx-examples/master/homebrew-patches/org.freedesktop.dbus-session.plist.osx.diff"
      sha256 "a8aa6fe3f2d8f873ad3f683013491f5362d551bf5d4c3b469f1efbc5459a20dc"
    end
  else
    patch do
      url "https://raw.githubusercontent.com/zbentley/dbus-osx-examples/master/homebrew-patches/org.freedesktop.dbus-session.plist.osx-old.diff"
      sha256 "da17af8e014d942d6e916a406ad7c901eebe6c3c7780318069db29e6c1e9ca67"
    end
  end

  def plist_name
    "org.freedesktop.dbus-session"
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
  end

  def post_install
    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  test do
    system "#{bin}/dbus-daemon", "--version"
  end
end