require 'formula'

class Phantomjs < Formula
  url "https://phantomjs.googlecode.com/files/phantomjs-1.3.0-source.tar.gz"
  head "https://github.com/ariya/phantomjs.git"
  homepage 'http://www.phantomjs.org/'
  sha1 "76902ad0956cf212cc9bb845f290690f53eca576"

  depends_on 'qt'

  def install
    system "qmake -spec macx-g++"
    system "make"
    bin.install "bin/phantomjs"
  end
end
