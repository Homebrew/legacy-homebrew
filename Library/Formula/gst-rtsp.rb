require 'formula'

class GstRtsp < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-rtsp/gst-rtsp-0.10.6.tar.bz2'
  md5 '8762d013f93f6aed39894f7eaf7bce86'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  def install
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--disable-schemas-install",
                           "--disable-gtk-doc"
    system "make"
    system "make install"
  end
end
