class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.104.tar.gz"
  sha256 "bfc1f1a82bfc3ec3ecafe04d0e87bab7e999f50dce4f4a34d0b89caf6bd821f6"

  bottle do
    sha256 "b32228702ab3d7e4b518dbe0481c631f0ad89377804ce46bdb96f952fc2489f8" => :yosemite
    sha256 "fe8132af05fb6bcc70679c4b82406fc727fd2e6272e9b57d1d91592c4415f1c8" => :mavericks
    sha256 "75eade40f2f89acf2b93a17e7492dad4a2a63f5375ec28446628bdd9ac4647f8" => :mountain_lion
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
