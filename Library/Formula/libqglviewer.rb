require 'formula'

class Libqglviewer < Formula
  homepage 'http://www.libqglviewer.com/'
  url 'http://www.libqglviewer.com/src/libQGLViewer-2.5.1.tar.gz'
  sha1 '21e10a28153cb649e29bbe9a288eecc280b30f0e'

  head 'https://github.com/GillesDebunne/libQGLViewer.git'

  bottle do
    cellar :any
    revision 1
    sha1 "9fa813e1c6af88267a9d76ef9bcd6bcf778c6fb5" => :yosemite
    sha1 "65093ea7674244be57591ec6ad5ee692c47573cd" => :mavericks
    sha1 "2e472e6ff337837cc9fd9d61e4c4fd5856e28589" => :mountain_lion
  end

  option :universal

  depends_on 'qt'

  def install
    args = ["PREFIX=#{prefix}"]
    args << "CONFIG += x86 x86_64" if build.universal?

    cd 'QGLViewer' do
      system "qmake", *args
      system "make"
    end
  end
end
