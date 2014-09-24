require "formula"

class Gstreamer < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.1.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.4.1.tar.xz"
  sha256 "5638f75003282135815c0077d491da11e9a884ad91d4ba6ab3cc78bae0fb452e"

  bottle do
    sha1 "f961f4aa1092ac485dea482920b90b01c5531b58" => :mavericks
    sha1 "8fe3563b0dbee45882dcba3fc23f2065c3e6fe46" => :mountain_lion
    sha1 "40d0350da6bb5988d7e42db4a870ff738a252c69" => :lion
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
