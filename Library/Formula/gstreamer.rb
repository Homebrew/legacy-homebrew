require 'formula'

class Gstreamer < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-0.10.34.tar.bz2'
  sha256 '85348f70dc4b70ad1beb05c9a59a64175c5058f4ee5273f89230a3c1d11b26a3'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-0.10 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/0.10/lib/gstreamer-0.10, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-0.10\""

    ENV.append "CFLAGS", "-funroll-loops -fstrict-aliasing -fno-common"
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
      "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
