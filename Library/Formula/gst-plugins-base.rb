class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "http://gstreamer.freedesktop.org/"
  url "https://download.gnome.org/sources/gst-plugins-base/1.6/gst-plugins-base-1.6.2.tar.xz"
  sha256 "c75dd400e451526ed71e1c4955e33d470a2581f5e71ecf84920a41c0a5c75322"

  bottle do
    sha256 "1185b081a3cbaa4b8bab072212656b1901be0ea4cf9f559a339a8cbba1d1f688" => :el_capitan
    sha256 "5218d039d3556f5f4a2c9401c174d60bca13c84591c93b3459ed1194b224971a" => :yosemite
    sha256 "4c9391e8e6f064e0a78dc56250f0a92d4b431b200eb1dfc825aa82454298a985" => :mavericks
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-plugins-base"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-base-0.10.35/REQUIREMENTS and Homebrew formulae
  depends_on "gobject-introspection"
  depends_on "orc" => :optional
  depends_on "gtk+" => :optional
  depends_on "libogg" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional

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
      --enable-introspection=yes
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
