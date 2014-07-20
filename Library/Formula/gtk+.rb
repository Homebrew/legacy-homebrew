require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.24.tar.xz'
  sha256 '12ceb2e198c82bfb93eb36348b6e9293c8fdcd60786763d04cfec7ebe7ed3d6d'

  bottle do
    sha1 "4184a042793c666df9366bc77363abe8347500d4" => :mavericks
    sha1 "2ba5cee75349a4d87b43e440c04a1e36b4a8f2da" => :mountain_lion
    sha1 "e7195bd0e896693f940e5000a860be205885fc2c" => :lion
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
