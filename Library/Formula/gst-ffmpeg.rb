require 'formula'

class GstFfmpeg <Formula
  url 'http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.10.tar.bz2'
  homepage 'http://gstreamer.freedesktop.org/'
  md5 '447292deff5f3748444e6a5fba41da29'

  depends_on 'gst-plugins-base'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
