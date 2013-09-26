require 'formula'

class Clutter < Formula
  homepage 'https://wiki.gnome.org/Clutter'
  url 'http://download.gnome.org/sources/clutter/1.16/clutter-1.16.0.tar.xz'
  sha256 'a213c7859051d6d19b5550c7e433757a35aa8e2b61a43d2eae83dd87912ea8ae'

  option 'without-x', 'Build without X11 support'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'gdk-pixbuf'
  depends_on 'cogl'
  depends_on 'cairo' # for cairo-gobject
  depends_on 'atk'
  depends_on 'pango'
  depends_on 'json-glib'
  depends_on :x11 unless build.include? 'without-x'

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --disable-introspection
      --disable-silent-rules
      --disable-Bsymbolic
      --disable-tests
      --disable-examples
      --disable-gtk-doc-html
      --enable-quartz-backend
    ]
    args << '--disable-x11-backend' << '--without-x' if build.include? 'without-x'
    system './configure', *args
    system 'make install'
  end
end
