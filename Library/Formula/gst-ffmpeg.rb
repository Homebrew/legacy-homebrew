require 'formula'

class GstFfmpeg < Formula
  url 'http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2'
  homepage 'http://gstreamer.freedesktop.org/'
  sha1 '8de5c848638c16c6c6c14ce3b22eecd61ddeed44'

  depends_on 'gst-plugins-base'
  # ffmpeg is bundled with gst-ffmpeg

  def install
    system './configure', "--prefix=#{prefix}",
                          "--with-ffmpeg-extra-configure=--cc=#{ENV.cc}",
                          '--disable-dependency-tracking'
    system "make install"
  end
end
