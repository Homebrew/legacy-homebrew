require "formula"

class Gtkx3 < Formula
  homepage "http://gtk.org/"
  url "http://ftp.gnome.org/pub/gnome/sources/gtk+/3.14/gtk+-3.14.6.tar.xz"
  sha256 "cfc424e6e10ffeb34a33762aeb77905c3ed938f0b4006ddb7e880aad234ef119"

  bottle do
    sha1 "f2074aa249d5695a575a210d2452e8182f8c3435" => :yosemite
    sha1 "406cc2d01dadccd00a995459c8f16d0e4fab7299" => :mavericks
    sha1 "abe63c674b9bf60027629c480536ae8454a6ab29" => :mountain_lion
  end

  option :universal

  depends_on :x11 => ["2.5", :recommended] # needs XInput2, introduced in libXi 1.3
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "gdk-pixbuf"
  depends_on "pango"
  depends_on "cairo"
  depends_on "jasper" => :optional
  depends_on "atk"
  depends_on "at-spi2-atk" if build.with? "x11"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas" => :recommended

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --enable-introspection=yes
      --disable-schemas-compile
    ]

    if build.without? "x11"
      args << "--enable-quartz-backend" << "--enable-quartz-relocation"
    else
      args << "--enable-x11-backend"
    end

    system "./configure", *args
    system "make", "install"
    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end
end
