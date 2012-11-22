require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.11.tar.xz'
  sha256 '328b4ea19a61040145e777e2ac49820968a382ac8581a380c9429897881812a9'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional
  depends_on 'cairo'

  option 'without-x', 'Build GTK+ without X11'
  option 'with-quartz', 'Build GTK+ with Quartz (without-x is assumed'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

    if build.include? 'without-x'
      args << '--without-x' << '--with-xinput=no' 
    end

    if build.include? 'with-quartz'
        args << '--with-gdktarget=quartz' << '--without-x' << '--with-xinput=no'
    end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-introspection",
                          "--disable-visibility"
    system "make install"
  end

  def test
    system "#{bin}/gtk-demo"
  end
end
