require 'formula'

class Gtkx3 < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.10/gtk+-3.10.7.tar.xz'
  sha256 'b7e9de15385031cff43897e7e59f6692eaabf500f36eef80e6b9d6486ad49427'

  depends_on :x11 => '2.5' # needs XInput2, introduced in libXi 1.3
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

  # Upstream patch to fix missing return value
  patch do
    url "https://git.gnome.org/browse/gtk+/patch/?id=1c42bb5e34783ea7170e96905d9d60e07e23933f"
    sha1 "526ec4a577b24000ba88b32cac366a1c333c68eb"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--enable-introspection=yes",
                          "--enable-x11-backend",
                          "--disable-schemas-compile"
    system "make install"
    # Prevent a conflict between this and Gtk+2
    mv bin/'gtk-update-icon-cache', bin/'gtk3-update-icon-cache'
  end

  test do
    system "#{bin}/gtk3-demo"
  end
end
