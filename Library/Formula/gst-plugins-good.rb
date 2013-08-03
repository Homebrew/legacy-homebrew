require 'formula'

class GstPluginsGood < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.0.8.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-good-1.0.8.tar.xz'
  sha256 '97831570ccdd8e15557f18858b965e54433d572d27fdabebb8b710cee276cfad'

  head 'git://anongit.freedesktop.org/gstreamer/gst-plugins-good'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-good-0.10.30/REQUIREMENTS and Homebrew formulae
  depends_on 'orc' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'aalib' => :optional
  depends_on 'libcdio' => :optional
  depends_on 'esound' => :optional
  depends_on 'flac' => :optional
  depends_on 'jpeg' => :optional
  depends_on 'libcaca' => :optional
  depends_on 'libdv' => :optional
  depends_on 'libshout' => :optional
  depends_on 'speex' => :optional
  depends_on 'taglib' => :optional
  depends_on 'check'
  depends_on 'libsoup'

  def install
    ENV.append "NOCONFIGURE", "yes" if build.head?

    args = %W[
       --prefix=#{prefix}
       --disable-schemas-install
       --disable-gtk-doc
       --disable-goom
       --with-default-videosink=ximagesink
    ]

    args << "--enable-debug" if build.head?
    args << "--enable-dependency-tracking" if build.head?

    args << "--disable-debug" if not build.head?
    args << "--disable-dependency-tracking" if not build.head?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make install"
  end
end
