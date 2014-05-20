require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.23.tar.xz'
  sha256 'a0a406e27e9b5e7d6b2c4334212706ed5cdcd41e713e66c9ae950655dd61517c'

  bottle do
    revision 1
    sha1 "dfa2e62f652ed55e60b5b6c29cec646971c9a501" => :mavericks
    sha1 "2e6b6f288ddc866baaef673867bd402bf5e1b0dd" => :mountain_lion
    sha1 "a164ed8199f61834a6bd852b2d7bb4bc580f9ff5" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk'
  depends_on 'cairo'
  depends_on :x11 => '2.3.6'
  depends_on 'gobject-introspection'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--enable-introspection=yes",
                          "--disable-visibility"
    system "make install"
  end
end
