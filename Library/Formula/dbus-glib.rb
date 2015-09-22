class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.104.tar.gz"
  sha256 "bfc1f1a82bfc3ec3ecafe04d0e87bab7e999f50dce4f4a34d0b89caf6bd821f6"

  bottle do
    cellar :any
    revision 1
    sha256 "9aac5cf8aedbb2cdc38ee8d040584fd16611ddc690893227fac6402a0979602d" => :el_capitan
    sha256 "da36f23e2cc221c1229919d49140980db27cd911233fabba36969ccf56f5ee1b" => :yosemite
    sha256 "097a1702c947ad9310ab0812c585eb3065bb1c127a7c856525fd299ec1d442ca" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "d-bus"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"dbus-binding-tool", "--help"
  end
end
