require 'formula'

class Libqglviewer < Formula
  url 'http://www.libqglviewer.com/src/libQGLViewer-2.3.9.tar.gz'
  homepage 'http://www.libqglviewer.com/index.html'
  md5 'a882cb3a8da4ee904a33b46ebb44f905'
  version '2.3.9'

  depends_on 'qt'

  def install
    system "cd QGLViewer"
    system "qmake", "PREFIX=#{prefix}"
    system "make"
    system "make install"
  end
end
