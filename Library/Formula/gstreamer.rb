require "formula"

class Gstreamer < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.0.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.4.0.tar.xz"
  sha256 "23c39fdc2b24f889b07cab0449825384fef7592a121e180729fd9025ec45c695"

  bottle do
    sha1 "79d453bf6cc25ad5389addd1eba6610f5ce3b43f" => :mavericks
    sha1 "f6f99cc4d73d97ece0f61e0fb7310e4c4639c449" => :mountain_lion
    sha1 "7c984213e35e568cd6c9fbb5dc93deeda8e7fa69" => :lion
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gstreamer"

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "gettext"
  depends_on "glib"
  depends_on "bison"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-gtk-doc
      --enable-introspection=yes
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-1.0\""

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
