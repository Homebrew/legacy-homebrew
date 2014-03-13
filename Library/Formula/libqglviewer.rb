require 'formula'

class Libqglviewer < Formula
  homepage 'http://www.libqglviewer.com/'
  url 'http://www.libqglviewer.com/src/libQGLViewer-2.5.1.tar.gz'
  sha1 '21e10a28153cb649e29bbe9a288eecc280b30f0e'

  head 'https://github.com/GillesDebunne/libQGLViewer.git'

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

  def caveats; <<-EOS.undent
    To avoid issues with runtime linking and facilitate usage of the library:
      sudo ln -s "#{prefix}/QGLViewer.framework" "/Library/Frameworks/QGLViewer.framework"
    EOS
  end
end
