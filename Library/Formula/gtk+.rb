require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.24.tar.xz'
  sha256 '12ceb2e198c82bfb93eb36348b6e9293c8fdcd60786763d04cfec7ebe7ed3d6d'

  bottle do
    revision 2
    sha1 "0d3be75e89887d0728d9fb3df6146e4b5b6305bf" => :yosemite
    sha1 "463b895e62bded89515b626b1c28218f9e4c9e9b" => :mavericks
    sha1 "c05e08a823fe2e710af29a7aa94b49692e22addd" => :mountain_lion
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
  depends_on :x11 => ['2.3.6', :recommended]
  depends_on 'gobject-introspection'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--disable-visibility"]

    args << "--with-gdktarget=quartz" if build.without?("x11")
    args << "--enable-quartz-relocation" if build.without?("x11")

    system "./configure", *args
    system "make install"
  end
end
