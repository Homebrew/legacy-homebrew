require 'formula'

class Gstreamer < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.0.8.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.0.8.tar.xz'
  sha256 'ff70f45509566b88e35986971ace5e89cb6cb232e9ca249f84502abceef1762d'

  head 'git://anongit.freedesktop.org/gstreamer/gstreamer'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gobject-introspection' => :optional
  depends_on 'gettext'
  depends_on 'glib'

  def install
    ENV.append "CFLAGS", "-funroll-loops -fstrict-aliasing -fno-common"
    ENV.append "NOCONFIGURE", "yes" if build.head?

    args = ["--prefix=#{prefix}"]
    args << "--enable-debug" if build.head?
    args << "--enable-dependency-tracking" if build.head?
    args << "--disable-gtk-doc" if build.head?

    args << "--disable-debug" if not build.head?
    args << "--disable-dependency-tracking" if not build.head?

    system "./autogen.sh" if build.head?

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-1.0\""

    system "./configure", *args
    system "make"
    system "make install"
  end
end
