class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "http://gstreamer.freedesktop.org/"

  stable do
    url "http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.6.3.tar.xz"
    sha256 "24b19db70b2a83461ebddfe20033db432dadfdb5d4b54ffb1dfa0d830134a177"

    depends_on "check" => :optional
  end

  bottle do
    sha256 "fee6df358f528fe94b973dda56e9c44da835962db37adf20a6b1dd8559ac68d0" => :el_capitan
    sha256 "80eef4283ae2dc5430436eb9c59ec31016498a053f0505cb7eee5c665049b507" => :yosemite
    sha256 "2654c35e4c890322a472cfe07ac421692bfc1433a96eb87cca61de7a3192d04b" => :mavericks
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-plugins-good"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "check"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "libsoup"

  depends_on :x11 => :optional

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-good-0.10.30/REQUIREMENTS and Homebrew formulae
  depends_on "orc" => :optional
  depends_on "gtk+" => :optional
  depends_on "aalib" => :optional
  depends_on "libcdio" => :optional
  depends_on "esound" => :optional
  depends_on "flac" => [:optional, "with-libogg"]
  depends_on "jpeg" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdv" => :optional
  depends_on "libshout" => :optional
  depends_on "speex" => :optional
  depends_on "taglib" => :optional
  depends_on "libpng" => :optional
  depends_on "libvpx" => :optional
  depends_on "pulseaudio" => :optional

  depends_on "libogg" if build.with? "flac"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-gtk-doc
      --disable-goom
      --with-default-videosink=ximagesink
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--disable-x"
    end

    # This plugin causes hangs on Snow Leopard (and possibly other versions?)
    # Upstream says it hasn't "been actively tested in a long time";
    # successor is glimagesink (in gst-plugins-bad).
    # https://bugzilla.gnome.org/show_bug.cgi?id=756918
    args << "--disable-osx_video" if MacOS.version == :snow_leopard

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
