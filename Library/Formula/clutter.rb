require 'formula'

class Clutter < Formula
  homepage 'https://wiki.gnome.org/Clutter'
  url 'http://ftp.gnome.org/pub/GNOME/sources/clutter/1.18/clutter-1.18.0.tar.xz'
  sha256 '937ac94d10d4562c67554dd3d087bf0859a3bf254922a226fc0c13a39a457869'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gdk-pixbuf'
  depends_on 'cogl'
  depends_on 'cairo' # for cairo-gobject
  depends_on 'atk'
  depends_on 'pango'
  depends_on 'json-glib'

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
      --without-x --enable-x11-backend=no
      --enable-gdk-pixbuf=no
      --enable-quartz-backend=yes
    ]

    system './configure', *args
    system 'make install'
  end
end
