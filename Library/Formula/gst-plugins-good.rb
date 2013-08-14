require 'formula'

class GstPluginsGood < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.0.9.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-good-1.0.9.tar.xz'
  sha256 'cfa2e617a76f93e9ddd4ae1109297e93fb4a06b152042b996231234a72c5a5ff'

  head 'git://anongit.freedesktop.org/gstreamer/gst-plugins-good'

  if build.head?
    depends_on :automake
    depends_on :libtool
    depends_on 'check'
  else
    depends_on 'check' => :optional
  end

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'
  depends_on 'libsoup'

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

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-schemas-install
      --disable-gtk-doc
      --disable-goom
      --with-default-videosink=ximagesink
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV.append "NOCONFIGURE", "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
