require "formula"

class TelepathyGlib < Formula
  homepage "http://telepathy.freedesktop.org/wiki/"
  url "http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.0.tar.gz"
  sha1 "43a3e9f3e08725b689aba3baa487c9711d436888"

  bottle do
    revision 1
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
    system "make install"
  end
end
