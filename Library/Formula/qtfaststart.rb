require 'formula'

class Qtfaststart < Formula
  homepage 'http://libav.org/'
  url 'http://libav.org/releases/libav-0.8.3.tar.gz'
  sha1 'd81a156e6482b970a21c5e08239eaf1d841b9b35'

  def install
    system ENV.cc, '-o', 'tools/qt-faststart', 'tools/qt-faststart.c'
    bin.install 'tools/qt-faststart'
  end
end
