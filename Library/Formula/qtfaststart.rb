require 'formula'

class Qtfaststart < Formula
  homepage 'http://ffmpeg.org/'
  url 'http://ffmpeg.org/releases/ffmpeg-2.1.1.tar.bz2'
  sha1 'e7a5b2d7f702c4e9ca69e23c6d3527f93de0d1bd'

  def install
    system ENV.cc, '-o', 'tools/qt-faststart', 'tools/qt-faststart.c'
    bin.install 'tools/qt-faststart'
  end
end
