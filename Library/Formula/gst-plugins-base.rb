class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "http://gstreamer.freedesktop.org/"
  url "https://download.gnome.org/sources/gst-plugins-base/1.6/gst-plugins-base-1.6.0.tar.xz"
  sha256 "314fd1b707f65caf8eb6164d9422fc51e2b220a890ccd2de6ec03a2883d77231"

  bottle do
    sha256 "e1c9b62174870496f06c2a31c639b267559cf0d5bbd6344042d6798c528890c9" => :el_capitan
    sha256 "d923837664e2ae437b3a9f8e5251794c50e721f761f601df9128ef0d2a60b7b1" => :yosemite
    sha256 "b99d142014674fcecffb2920a6fae7c4862c4ca4f1f817690dbe5dfd931f14db" => :mavericks
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
