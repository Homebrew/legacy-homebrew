require 'formula'

class Qtfaststart < Formula
  homepage 'http://libav.org/'
  url 'http://libav.org/releases/libav-0.8.3.tar.gz'
  version "0.8.3"
  md5 "b76d78e799afa53782b9c3771671b3bd"

  def install

    system 'cc', '-o', 'tools/qt-faststart', 'tools/qt-faststart.c'
    bin.install 'tools/qt-faststart'

  end

end
