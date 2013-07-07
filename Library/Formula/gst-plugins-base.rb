require 'formula'

class GstPluginsBase < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.0.7.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-base-1.0.7.tar.xz'
  sha256 '014805e50b696bc06c3862ea656df079fc0b5fef0c10f16e9f085f290545677a'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'gstreamer'

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-base-0.10.35/REQUIREMENTS and Homebrew formulae
  depends_on 'gobject-introspection' => :optional
  depends_on 'orc' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'libogg' => :optional
  depends_on 'pango' => :optional
  depends_on 'theora' => :optional
  depends_on 'libvorbis' => :optional

  def install
    # gnome-vfs turned off due to lack of formula for it.
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-experimental
      --disable-libvisual
      --disable-alsa
      --disable-cdparanoia
      --without-x
      --disable-x
      --disable-xvideo
      --disable-xshm
    ]
    system "./configure", *args
    system "make"
    system "make install"
  end
end
