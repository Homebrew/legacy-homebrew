require "formula"

class TelepathyGlib < Formula
  homepage "http://telepathy.freedesktop.org/wiki/"
  url "http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.0.tar.gz"
  sha1 "43a3e9f3e08725b689aba3baa487c9711d436888"

  bottle do
    sha1 "fbe22e4204d03da7d54ffbca469a6ed6f7fb8a73" => :mavericks
    sha1 "d58cdac4945b50a985e2c47052f3aaeb136b50df" => :mountain_lion
    sha1 "6708431e97da80f649bf73fb12cc6d4c1a53b915" => :lion
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
