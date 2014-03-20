require 'formula'

class Clutter < Formula
  homepage 'https://wiki.gnome.org/Clutter'
  url 'http://ftp.gnome.org/pub/GNOME/sources/clutter/1.16/clutter-1.16.4.tar.xz'
  sha256 'cf50836ec5503577b73f75f984577610881b3e2ff7a327bb5b6918b431b51b65'

  option 'without-x', 'Build without X11 support'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gdk-pixbuf'
  depends_on 'cogl'
  depends_on 'cairo' # for cairo-gobject
  depends_on 'atk'
  depends_on 'pango'
  depends_on 'json-glib'
  depends_on :x11 => '2.5.1' if build.with? 'x'

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
    ]

    if build.with? 'x'
      args.concat %w{
        --with-x --enable-x11-backend=yes
        --enable-gdk-pixbuf=yes
        --enable-quartz-backend=no
      }
    else
      args.concat %w{
        --without-x --enable-x11-backend=no
        --enable-gdk-pixbuf=no
        --enable-quartz-backend=yes
      }
    end

    system './configure', *args
    system 'make install'
  end
end
