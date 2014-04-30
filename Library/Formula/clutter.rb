require "formula"

class Clutter < Formula
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "http://ftp.gnome.org/pub/gnome/sources/clutter/1.14/clutter-1.14.4.tar.xz"
  sha256 "c996d91fff6fff24d9e23dcd545439ebc6b999fb1cf9ee44c28ca54c49c0ee1c"

  option "without-x", "Build without X11 support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gdk-pixbuf"
  depends_on "cogl"
  depends_on "cairo" # for cairo-gobject
  depends_on "atk"
  depends_on "pango"
  depends_on "json-glib"
  depends_on :x11 => "2.5.1" if build.with? "x"
  depends_on "gobject-introspection"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-silent-rules
      --disable-Bsymbolic
      --disable-tests
      --disable-examples
      --disable-gtk-doc-html
    ]

    if build.with? "x"
      args.concat %w{
        --with-x --enable-x11-backend=yes
        --enable-gdk-pixbuf=yes
        --enable-quartz-backend=no
      }
    else
      args.concat %w{
        --without-x --enable-x11-backend=no
        --enable-gdk-pixbuf=no
        --enable-quartz-backend=yes
      }
    end

    system "./configure", *args
    system "make install"
  end
end
