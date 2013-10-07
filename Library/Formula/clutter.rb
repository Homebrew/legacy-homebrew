require 'formula'

class Clutter < Formula
  homepage 'https://wiki.gnome.org/Clutter'
  url 'http://ftp.gnome.org/pub/gnome/sources/clutter/1.14/clutter-1.14.4.tar.xz'
  sha256 'c996d91fff6fff24d9e23dcd545439ebc6b999fb1cf9ee44c28ca54c49c0ee1c'

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
