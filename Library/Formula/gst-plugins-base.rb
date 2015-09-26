class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "http://gstreamer.freedesktop.org/"
  url "https://download.gnome.org/sources/gst-plugins-base/1.6/gst-plugins-base-1.6.0.tar.xz"
  sha256 "314fd1b707f65caf8eb6164d9422fc51e2b220a890ccd2de6ec03a2883d77231"

  bottle do
    sha256 "e4299d056a51ab06dbda85620d66751908b21f736f0f4afba144e5c3d32706d3" => :el_capitan
    sha1 "8e9098a2afac082a3eb54bf0c62387f827443ef6" => :yosemite
    sha1 "ab9e0aef6bf01b6e5ff379a1c0d694a588ea938d" => :mavericks
    sha1 "eb0cea91727094bf924aac81a21bc71c7d4f8e68" => :mountain_lion
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
