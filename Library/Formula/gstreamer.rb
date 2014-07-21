require "formula"

class Gstreamer < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.0.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.4.0.tar.xz"
  sha256 "23c39fdc2b24f889b07cab0449825384fef7592a121e180729fd9025ec45c695"

  bottle do
    sha1 "5c486386d1b9b08d2a330846839d58d700c4f86d" => :mavericks
    sha1 "3a2f80ec51ba96425b07d5101cc430aebad65d0f" => :mountain_lion
    sha1 "d8f626c61d01617d6091a5d466bdda7c94d06bfd" => :lion
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
