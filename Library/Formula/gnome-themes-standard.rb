require 'formula'

class GnomeThemesStandard < Formula
  homepage 'http://gnome.org/'
  url 'http://ftp.gnome.org/Public/GNOME/sources/gnome-themes-standard/3.12/gnome-themes-standard-3.12.0.tar.xz'
  sha256 'a05d1b7ca872b944a69d0c0cc2369408ece32ff4355e37f8594a1b70d13c3217'

  depends_on 'librsvg'
  depends_on 'intltool' => :build
  depends_on 'libsvg-cairo' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'gtk+3' => :recommended
  depends_on 'gdk-pixbuf'

  def install
    args = []
    args << "--disable-gtk3-engine" if build.without? 'gtk+3'

    system "./configure", *args
    ENV["GDK_PIXBUF_MODULEDIR"]="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "make install"
  end
end
