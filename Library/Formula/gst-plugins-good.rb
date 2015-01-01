require 'formula'

class GstPluginsGood < Formula
  homepage 'http://gstreamer.freedesktop.org/'

  stable do
    url 'http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.4.5.tar.xz'
    mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-good-1.4.5.tar.xz'
    sha256 "79b1b5f3f7bcaa8a615202eb5e176121eeb8336960f70687e536ad78dbc7e641"

    depends_on 'check' => :optional
  end

  bottle do
    sha1 "c4e04ab1b2a9f85cb1ecf09844cf2797fa7d6aa9" => :yosemite
    sha1 "2e3355b746cd25d6153449f6ff8208216301ca1b" => :mavericks
    sha1 "6bc77cab1c10d557d086f228640ae5e42080cf8b" => :mountain_lion
  end

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gst-plugins-good'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on 'check'
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'
  depends_on 'libsoup'

  depends_on :x11 => :optional

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-good-0.10.30/REQUIREMENTS and Homebrew formulae
  depends_on 'orc' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'aalib' => :optional
  depends_on 'libcdio' => :optional
  depends_on 'esound' => :optional
  depends_on 'flac' => [:optional, 'with-libogg']
  depends_on 'jpeg' => :optional
  depends_on 'libcaca' => :optional
  depends_on 'libdv' => :optional
  depends_on 'libshout' => :optional
  depends_on 'speex' => :optional
  depends_on 'taglib' => :optional
  depends_on 'libpng' => :optional
  depends_on 'libvpx' => :optional

  depends_on 'libogg' if build.with? 'flac'

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

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
