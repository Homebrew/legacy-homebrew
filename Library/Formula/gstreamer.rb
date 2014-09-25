require "formula"

class Gstreamer < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.3.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.4.3.tar.xz"
  sha256 "11f155784d28b85a12b50d2fc8f91c6b75d9ca325cc76aaffba1a58d4c9549c9"

  bottle do
    sha1 "2d81c875848444a8fa1f9591a06064125244525d" => :mavericks
    sha1 "117adca1dfeb12778ae9044a7e5e7562bc7c825f" => :mountain_lion
    sha1 "1b461fc73804d7df6517bbea3edcc07fd929652d" => :lion
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
