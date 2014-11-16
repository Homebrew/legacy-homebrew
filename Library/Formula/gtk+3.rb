require 'formula'

class Gtkx3 < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.14/gtk+-3.14.4.tar.xz'
  sha256 'a006c716d723dab0c623491566e3292af84c87d9198a30199051d23cfc7bef2f'

  bottle do
    sha1 "54ad82781a6f423b00acfdfc8425f21099b8ef1d" => :yosemite
    sha1 "d182700a63a4de1d82db7036b7a728a23b5111f0" => :mavericks
    sha1 "cee7dfbdecacadd2b8dea994ce698364fd2045c6" => :mountain_lion
  end

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

  # These two patches fix a compilation error on Snow Leopard when
  # using quartz backend (no effect on later OS versions)
  # Can be removed when upstream releases these commits (3.14.5?)
  # See: https://bugzilla.gnome.org/show_bug.cgi?id=737561
  patch do
    url "https://git.gnome.org/browse/gtk+/patch/?id=7d3991f2757de8374e11891e21e82f61242b4034"
    sha1 "66dc9d63ba6d2f9219d0dbe27f2dd8343b07ab0c"
  end

  patch do
    url "https://git.gnome.org/browse/gtk+/patch/?id=830a72b307b33815179aa0b03dad498c9ac1bb14"
    sha1 "5a39469d8923ac9ce1f6511c4e304f7e1cba781c"
  end

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
