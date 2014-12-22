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
    sha1 "42ddc43233247a8cb90da2fc64b90ffd83c25dd1" => :yosemite
    sha1 "07ab214b44b9e78a7d963f164454a1cb19da7372" => :mavericks
    sha1 "89e2f6c8b1b738c24058e38b17e2286922ad63f9" => :mountain_lion
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
