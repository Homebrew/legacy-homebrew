require 'formula'

class GstPluginsGood < Formula
  homepage 'http://gstreamer.freedesktop.org/'

  stable do
    url 'http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.4.0.tar.xz'
    mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-good-1.4.0.tar.xz'
    sha256 '48a62e7987fffa289a091dfc8ccc80b401d110632b8fc1adce5b82fc092f2685'

    depends_on 'check' => :optional
  end

  bottle do
    sha1 "e4962534c01fa90443ebc05fcc153b8d1a17e3f9" => :mavericks
    sha1 "9be1005b6db6ad4877547262b1277c3dbe9dd43e" => :mountain_lion
    sha1 "13d6763c57af2fc6eb7f515b28d020048761a603" => :lion
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
