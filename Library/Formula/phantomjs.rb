require 'formula'

class Phantomjs < Formula
  url "http://phantomjs.googlecode.com/files/phantomjs-1.1.0-source.zip"
  head "https://github.com/ariya/phantomjs.git"
  homepage 'http://www.phantomjs.org/'
  sha1 "11b6023c9b2bd3e5f7dc7e3d4e4ce24588a3d396"

  depends_on 'qt'

  def install
    system "qmake -spec macx-g++"
    system "make"
    bin.install "bin/phantomjs.app/Contents/MacOS/phantomjs"
  end
end
