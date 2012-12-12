require 'formula'

class Libunique < Formula
  homepage 'http://live.gnome.org/LibUnique'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libunique/3.0/libunique-3.0.2.tar.bz2'
  sha256 '50269a87c7aabf1e25f01b3bbb280133138ffd7b6776289894c614a4b6ca968d'

  depends_on 'pkg-config' => :build
  depends_on 'dbus-glib'
  depends_on 'gtk+3'
  depends_on :x11

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-introspection
      --disable-maintainer-flags
      --disable-gtk-doc-html
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make install"
  end
end
