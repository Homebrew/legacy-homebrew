require 'formula'

class GstFfmpeg < Formula
  url 'http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.11.tar.bz2'
  homepage 'http://gstreamer.freedesktop.org/'
  md5 '0d23197ba7ac06ea34fa66d38469ebe5'

  depends_on 'gst-plugins-base'
  # ffmpeg is bundled with gst-ffmpeg

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
