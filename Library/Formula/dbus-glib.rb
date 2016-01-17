class DbusGlib < Formula
  desc "GLib bindings for the D-Bus message bus system"
  homepage "https://wiki.freedesktop.org/www/Software/DBusBindings/"
  url "http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.106.tar.gz"
  sha256 "b38952706dcf68bad9c302999ef0f420b8cf1a2428227123f0ac4764b689c046"

  bottle do
    cellar :any
    sha256 "621550837f7ee93fab562120edc5852e5af03f671dca773de3a8ea44008e5ad6" => :el_capitan
    sha256 "0fc755aa6af5b706275d82a782ce99188050084e504f7b865413db482ab1ed67" => :yosemite
    sha256 "fcac3d3c20ccb4a114b736dab4fb952e44d6f3ccecd5d2b69495d3474a0f24db" => :mavericks
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
