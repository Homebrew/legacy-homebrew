require "formula"

class Gstreamer < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.4.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gstreamer-1.4.4.tar.xz"
  sha256 "f0e305d91a93d05bf9e332cd4256ca07d77f5186a4d73847b7ae6db218f2c237"

  bottle do
    sha1 "3684b3cfd9aa5c8d00ca104062b3980d13d9d774" => :yosemite
    sha1 "10412679f79ec07b34231eced9847b98b176d76b" => :mavericks
    sha1 "74f8eac19b8b31f394dfe6e8051da2f9b0053823" => :mountain_lion
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gstreamer"

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on "xz" => :build
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
