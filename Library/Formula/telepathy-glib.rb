require "formula"

class TelepathyGlib < Formula
  homepage "http://telepathy.freedesktop.org/wiki/"
  url "http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.0.tar.gz"
  sha1 "43a3e9f3e08725b689aba3baa487c9711d436888"

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
