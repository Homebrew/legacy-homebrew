class Gstreamer < Formula
  desc "GStreamer is a development framework for multimedia applications"
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.5.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.4.5.tar.xz"
  sha256 "40801aa7f979024526258a0e94707ba42b8ab6f7d2206e56adbc4433155cb0ae"

  bottle do
    revision 2
    sha256 "ef286655192a6ee7283fbb536465062e55d8f7627993adcc67152c1d3ec8ee85" => :el_capitan
    sha256 "ac4e49623736041c7d8fdc981c155b7c40e12c17c0f7e04d2f32d2f0ee1b5ffb" => :yosemite
    sha256 "2a91498326318c4de55ddb5eae47b3540bbda7ac44166899886e5cc1c2ad7fb2" => :mavericks
    sha256 "b943636f153cc792c2d63e7ce68c4084d1ffff2987606e8ec95f1ef0a77cea82" => :mountain_lion
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gstreamer"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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

      # Ban trying to chown to root.
      # https://bugzilla.gnome.org/show_bug.cgi?id=750367
      args << "--with-ptp-helper-permissions=none"
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

  test do
    system bin/"gst-inspect-1.0"
  end
end
