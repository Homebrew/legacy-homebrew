require 'formula'

class GstPluginsBase < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.0.10.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-base-1.0.10.tar.xz'
  sha256 '9754e83b2a3ff61266112915bfc84c895c4d145519ad9a3381edceb216bc97e8'

  head 'git://anongit.freedesktop.org/gstreamer/gst-plugins-base'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  if build.with? 'gobject-introspection'
    depends_on 'gstreamer' => 'with-gobject-introspection'
  else
    depends_on 'gstreamer'
  end
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
      --enable-experimental
      --disable-libvisual
      --disable-alsa
      --disable-cdparanoia
      --without-x
      --disable-x
      --disable-xvideo
      --disable-xshm
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV.append "NOCONFIGURE", "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
