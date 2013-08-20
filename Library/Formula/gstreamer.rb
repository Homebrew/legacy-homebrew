require 'formula'

class Gstreamer < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.0.9.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.0.9.tar.xz'
  sha256 '17a2c60a82baa461ef685ad3de187edb9c03a2c7e07513daba58a5a32efacaa3'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gobject-introspection' => :optional
  depends_on 'gettext'
  depends_on 'glib'

  def install
    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-1.0\""

    ENV.append "CFLAGS", "-funroll-loops -fstrict-aliasing -fno-common"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
