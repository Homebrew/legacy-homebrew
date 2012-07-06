require 'formula'

class GstFfmpeg < Formula
  url 'http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2'
  homepage 'http://gstreamer.freedesktop.org/'
  md5 '7f5beacaf1312db2db30a026b36888c4'

  depends_on 'gst-plugins-base'
  # ffmpeg is bundled with gst-ffmpeg

  def install
    system './configure', "--prefix=#{prefix}",
                          "--with-ffmpeg-extra-configure=--cc=#{ENV.cc}",
                          '--disable-dependency-tracking'
    system "make install"
  end
end
