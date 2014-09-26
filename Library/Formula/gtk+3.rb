require 'formula'

class Gtkx3 < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.14/gtk+-3.14.0.tar.xz'
  sha256 '68d6b57d15c16808d0045e96b303f3dd439cc22a9c06fdffb07025cd713a82bc'

  bottle do
    revision 1
    sha1 "ed0ce70bdb9b8f70f3a7f292fa5a6218bb8393a3" => :mavericks
    sha1 "d4b3cb9c83fa76d5a2e62c8f1705e27aafd4928e" => :mountain_lion
    sha1 "c0dde5f4a0da96b2f025832c53706514529575ef" => :lion
  end

  depends_on :x11 => :recommended # (2.5) needs XInput2, introduced in libXi 1.3
  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'cairo'
  depends_on 'jasper' => :optional
  depends_on 'atk'
  depends_on 'at-spi2-atk'
  depends_on 'gobject-introspection'
  depends_on 'gsettings-desktop-schemas' => :recommended

  def install

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
