require "formula"

class Clutter < Formula
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "http://ftp.gnome.org/pub/gnome/sources/clutter/1.20/clutter-1.20.0.tar.xz"
  sha256 "cc940809e6e1469ce349c4bddb0cbcc2c13c087d4fc15cda9278d855ee2d1293"

  bottle do
    sha1 "f9ef97d254247e2e0ab98fbaf3723d577c115ab4" => :mavericks
    sha1 "063234b823140c65483e9ac0dbbf4af63764431b" => :mountain_lion
    sha1 "7565ae43a559f988271cfdf8a745cc7919659efe" => :lion
  end

  deprecated_option "without-x" => "without-x11"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gdk-pixbuf"
  depends_on "cogl"
  depends_on "cairo" # for cairo-gobject
  depends_on "atk"
  depends_on "pango"
  depends_on "json-glib"
  depends_on :x11 => ["2.5.1", :recommended]
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

    if build.with? "x11"
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
