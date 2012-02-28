require 'formula'

class Phantomjs < Formula
  url "https://phantomjs.googlecode.com/files/phantomjs-1.4.1-source.tar.gz"
  head "https://github.com/ariya/phantomjs.git"
  homepage 'http://www.phantomjs.org/'
  sha1 "d9386aa3e36bdd31f069f5301e315a9c5d91f06a"

  depends_on 'qt'

  def install
    system "qmake -spec macx-g++"
    system "make"
    bin.install "bin/phantomjs"
  end
end
