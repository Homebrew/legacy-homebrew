require 'formula'

class Gtkx3 < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/3.12/gtk+-3.12.0.tar.xz'
  sha256 'eb69741cd4029b5a1ac9cf04d9de55dcf9e30777a63891750f5d20cc554b6e4b'

  bottle do
    sha1 "9e2614c2560243bb2739c260b0c883a019321c14" => :mavericks
    sha1 "2dd7df2a669a1fb41512008160a4f2a383b35028" => :mountain_lion
    sha1 "6c9814dd0d3eef328823f782da098dc345135491" => :lion
  end

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

  def install
    # gtk-update-icon-cache is used during installation, and
    # we don't want to add a dependency on gtk+2 just for this.
    inreplace %w[ gtk/makefile.msc.in
                  demos/gtk-demo/Makefile.in
                  demos/widget-factory/Makefile.in ],
                  /gtk-update-icon-cache --(force|ignore-theme-index)/,
                  "#{buildpath}/gtk/\\0"

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
end
