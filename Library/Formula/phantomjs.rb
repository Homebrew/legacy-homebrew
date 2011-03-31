require 'formula'

class Phantomjs < Formula
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.0.0.tar.gz'
  head "git://github.com/ariya/phantomjs.git"
  homepage 'http://phantomjs.googlecode.com/'
  md5 '6aa18de82e24923fa1a1feeaf299ecef'

  depends_on 'qt'

  def install
    system "qmake -spec macx-g++"
    system "make"
    bin.install "bin/phantomjs.app/Contents/MacOS/phantomjs"
  end
end
