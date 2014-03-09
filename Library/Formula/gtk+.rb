require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.22.tar.xz'
  sha256 'b114b6e9fb389bf3aa8a6d09576538f58dce740779653084046852fb4140ae7f'

  bottle do
    sha1 "eb029bd3457b4928b7186b33091eb41df18f468d" => :mavericks
    sha1 "f28d77d1220574a9ec9b8910c2b6ab61a5b742df" => :mountain_lion
    sha1 "2cb6f9dfa6b11fedca439c5983f3723b4e852f85" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk'
  depends_on 'cairo'
  depends_on :x11 => '2.3.6'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-introspection",
                          "--disable-visibility"
    system "make install"
  end
end
