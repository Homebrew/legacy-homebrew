require 'formula'

class Libunique < Formula
  homepage 'http://live.gnome.org/LibUnique'
  url 'ftp://ftp.gnome.org/pub/GNOME/sources/libunique/1.1/libunique-1.1.6.tar.bz2'
  sha256 'e5c8041cef8e33c55732f06a292381cb345db946cf792a4ae18aa5c66cdd4fbb'
  head 'git://git.gnome.org/unique'

  depends_on 'pkg-config' => :build
  depends_on 'dbus-glib'
  depends_on 'gtk+'

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--enable-introspection=no",
            "--enable-maintainer-flags=no",
            "--prefix=#{prefix}"]

    system "./configure", *args
    system "make install"
  end
end
