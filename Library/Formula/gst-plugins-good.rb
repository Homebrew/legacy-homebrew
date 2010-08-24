require 'formula'

class GstPluginsGood <Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-0.10.24.tar.bz2'
  md5 'dc0de606e3e303cf378327b72a4d281f'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'gst-plugins-base'
  depends_on 'aalib' => :optional
  depends_on 'check' => :optional
  depends_on 'flac' => :optional
  depends_on 'libcaca' => :optional
  depends_on 'libcdio' => :optional
  depends_on 'libshout' => :optional
  depends_on 'orc' => :optional
  depends_on 'speex' => :optional
  depends_on 'taglib' => :optional

  def install
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--disable-schemas-install",
                           "--disable-gtk-doc",
                           "--disable-goom",
                           "--with-default-videosink=ximagesink"
    system "make"
    system "make install"
  end
end
