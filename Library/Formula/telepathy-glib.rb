class TelepathyGlib < Formula
  desc "Telepathy GLib library for clients and connection managers"
  homepage "http://telepathy.freedesktop.org/wiki/"
  url "http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.0.tar.gz"
  sha256 "ae0002134991217f42e503c43dea7817853afc18863b913744d51ffa029818cf"

  bottle do
    revision 1
    sha256 "12ad2cfa997e030a3f4e3e49f8cbbb50b026a4fa477c620ed219cef4e075e314" => :el_capitan
    sha1 "a98475645190b7d9253cc950b828d0ac05b72124" => :yosemite
    sha1 "f49fed685755aca7c829a779fae1f31855d0195c" => :mavericks
    sha1 "f01c372f200a12a9e573683a58c3a514a89c0aa9" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gobject-introspection"
  depends_on "dbus-glib"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-installed-tests
      --disable-installed-examples
      --disable-gtk-doc-html
    ]

    system "./configure", *args
    system "make", "install"
  end
end
