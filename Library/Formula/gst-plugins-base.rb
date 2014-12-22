require "formula"

class GstPluginsBase < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.4.5.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-base-1.4.5.tar.xz"
  sha256 "77bd8199e7a312d3d71de9b7ddf761a3b78560a2c2a80829d0815ca39cbd551d"

  bottle do
    sha1 "bc07df39b0ae799bbff2f22a55278cb6ac16a756" => :yosemite
    sha1 "068061fdc86d77b9e918b92ad257b0c31b9cf4ba" => :mavericks
    sha1 "b780ffc1eb74f37dbc7a18806d46cfde945e9c5b" => :mountain_lion
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
