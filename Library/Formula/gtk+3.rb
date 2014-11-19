require 'formula'

class Gtkx3 < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.14/gtk+-3.14.5.tar.xz'
  sha256 'ba70f5ccde6646c6d8aa5a6398794b7bcf23fc45af22580a215d258f392dbbe2'

  bottle do
  end

  option :universal

  depends_on :x11 => ['2.5', :recommended] # needs XInput2, introduced in libXi 1.3
  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'cairo'
  depends_on 'jasper' => :optional
  depends_on 'atk'
  depends_on 'at-spi2-atk' if build.with? "x11"
  depends_on 'gobject-introspection'
  depends_on 'gsettings-desktop-schemas' => :recommended

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
    system "make install"
    # Prevent a conflict between this and Gtk+2
    mv bin/'gtk-update-icon-cache', bin/'gtk3-update-icon-cache'
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end
end
