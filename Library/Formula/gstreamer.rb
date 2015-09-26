class Gstreamer < Formula
  desc "GStreamer is a development framework for multimedia applications"
  homepage "http://gstreamer.freedesktop.org/"
  url "https://download.gnome.org/sources/gstreamer/1.6/gstreamer-1.6.0.tar.xz"
  sha256 "52ef885647afef11c8b7645a9afefe04aa09e8971c4b932e7717872ab8a30fcc"

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
