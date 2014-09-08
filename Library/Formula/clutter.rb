require "formula"

class Clutter < Formula
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "http://ftp.gnome.org/pub/gnome/sources/clutter/1.18/clutter-1.18.4.tar.xz"
  sha256 "4eea1015cd6d4b4945cb5d4a60e52275b0d70e13852d6d99c9abc0cd4deeb60c"

  bottle do
    sha1 "de24b028cfc61d47b60e9d539dc5e3e2a8b41c8e" => :mavericks
    sha1 "5ae46c3e3f7196e7df4c467d38fb8ce2b6942584" => :mountain_lion
    sha1 "daf3abee60ec5e8cbbaa99c56223ae520e0d4fc3" => :lion
  end

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
