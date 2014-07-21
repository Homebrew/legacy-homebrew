require "formula"

class ClutterGtk < Formula
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "http://ftp.gnome.org/pub/gnome/sources/clutter-gtk/1.2/clutter-gtk-1.2.2.tar.xz"
  sha256 "743702bb230519553ca597b585b25af0b8783575fcd09c7fe5bed7dde292893c"

  option "without-x", "Build without X11 support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gdk-pixbuf"
  depends_on "cogl"
  depends_on "atk"
  depends_on "pango"
  depends_on "json-glib"
  depends_on :x11 => "2.5.1" if build.with? "x"
  depends_on "gtk+3"
  depends_on "clutter"
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
