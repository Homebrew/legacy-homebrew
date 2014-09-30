require 'formula'

class GstPluginsGood < Formula
  homepage 'http://gstreamer.freedesktop.org/'

  stable do
    url 'http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.4.3.tar.xz'
    mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-good-1.4.3.tar.xz'
    sha256 '5876a74402f2a24d1d3ae9163c32466bdc7a565696dddeef65e6a9a93efc5537'

    depends_on 'check' => :optional
  end

  bottle do
    sha1 "737fce473c770dad629f84f11b10fbe84554ead8" => :mavericks
    sha1 "56761f7f6a803714da6c5d676738382c788b0fee" => :mountain_lion
    sha1 "a6986b418e1e76bcaab34a7055ccdcd9233d38fd" => :lion
  end

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gst-plugins-good'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
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
