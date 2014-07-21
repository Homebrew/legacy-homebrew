require "formula"

class GstPluginsBase < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.2.4.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-base-1.2.4.tar.xz"
  sha256 "4d6273dc3f5a94bcc53ccfe0711cfddd49e31371d1136bf62fa1ecc604fc6550"

  bottle do
    sha1 "ab68aec98207b4fecd0067773b2b4341d75828da" => :mavericks
    sha1 "b692584a10865ce38daf450a92f2d968a3fe2938" => :mountain_lion
    sha1 "bf69ec83cdbae0f46452fa640bbdd067b9053447" => :lion
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-plugins-base"

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
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
