class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "http://gstreamer.freedesktop.org/"

  stable do
    url "https://download.gnome.org/sources/gst-plugins-good/1.6/gst-plugins-good-1.6.0.tar.xz"
    sha256 "a0915639595305e48884656e22b16fda7c6892aa02cdb3eb43e23dab6e6b81fa"

    depends_on "check" => :optional

    if MacOS.version < :lion
      # Snow Leopard and below don't have strnlen()
      # https://bugzilla.gnome.org/show_bug.cgi?id=756154
      # http://cgit.freedesktop.org/gstreamer/gst-plugins-good/commit/?id=fc203a4bd7eb1cecc0e17bcb7ec67e0672806867
      patch do
        url "https://bugzilla.gnome.org/attachment.cgi?id=313403&action=diff&context=patch&collapsed=&headers=1&format=raw"
        sha256 "63a2f18683c967d321f42fcfca0c1d8e070b489ce8f8b08f3340c30c6903250d"
      end
    end
  end

  bottle do
    sha256 "f0b959674f1bf2135378c640853971899df115830e047d0a33784671c35d17d4" => :el_capitan
    sha256 "1a3009aa7e6dc2cd2cffd598a0c9e1f3183a268460aa15ebd1f750153a4d0f9d" => :yosemite
    sha256 "cd42820977c3cdb2ca5315f7c86c1e041b523960fac07e767175958c873ff683" => :mavericks
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
