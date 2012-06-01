require 'formula'

class GstPluginsBase < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.bz2'
  sha256 '2cd3b0fa8e9b595db8f514ef7c2bdbcd639a0d63d154c00f8c9b609321f49976'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gstreamer'

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-base-0.10.35/REQUIREMENTS and Homebrew formulas
  depends_on 'orc' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'libogg' => :optional
  depends_on 'pango' => :optional
  depends_on 'theora' => :optional
  depends_on 'libvorbis' => :optional

  def install
    # gnome-vfs turned off due to lack of formula for it. MacPorts has it.
    system "./configure", *%w[--disable-debug
                              --disable-dependency-tracking
                              --enable-introspection=no
                              --enable-experimental
                              --disable-libvisual
                              --disable-alsa
                              --disable-cdparanoia
                              --without-x
                              --disable-x
                              --disable-xvideo
                              --disable-xshm
                              --disable-gnome_vfs]
    system "make"
    system "make install"
  end
end
