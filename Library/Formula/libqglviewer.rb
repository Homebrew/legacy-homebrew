require 'formula'

class Libqglviewer < Formula
  homepage 'http://www.libqglviewer.com/'
  url 'http://www.libqglviewer.com/src/libQGLViewer-2.5.1.tar.gz'
  sha1 '21e10a28153cb649e29bbe9a288eecc280b30f0e'

  head 'https://github.com/GillesDebunne/libQGLViewer.git'

  bottle do
    cellar :any
    sha1 "6c20fb8bac46fad1829c90f07b1d80b4ba797799" => :mavericks
    sha1 "c3abf90b9e9eaa835e5c5faa979670175e2715a2" => :mountain_lion
    sha1 "0ef379d978e5277914f9887bbf6240aa7f81294a" => :lion
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
