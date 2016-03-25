class Gstreamer < Formula
  desc "GStreamer is a development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.8.0.tar.xz"
  sha256 "947a314a212b5d94985d89b43440dbe66b696e12bbdf9a2f78967b98d74abedc"

  bottle do
    sha256 "6c1aaba475cf8466112a05c1e07f89c2a621c47cf3d9e3ab08a3afa5d6fd684f" => :el_capitan
    sha256 "189c1296fdefbc106ba4606bf4db59413d003e264209826a16958010a1debb11" => :yosemite
    sha256 "6bafb0043e53ea7a6be8fda05b850bcc450244c427bf6b87b93650857ca1a93b" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gstreamer.git"

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
