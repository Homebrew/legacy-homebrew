require 'formula'

class Phantomjs < Formula
  url "http://phantomjs.googlecode.com/files/phantomjs-1.2.0-source.zip"
  head "https://github.com/ariya/phantomjs.git"
  homepage 'http://www.phantomjs.org/'
  sha1 "0b8b20fbc45013ecf61dd988390dd979a894dec1"

  depends_on 'qt'

  def install
    system "qmake -spec macx-g++"
    system "make"
    bin.install "bin/phantomjs.app/Contents/MacOS/phantomjs"
  end
end
