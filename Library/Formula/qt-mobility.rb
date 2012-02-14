require 'formula'

class QtMobility < Formula
  url 'http://get.qt.nokia.com/qt/add-ons/qt-mobility-opensource-src-1.2.0.tar.gz'
  homepage 'http://qt.nokia.com/'
  md5 'ea5db5a8d3dd4709c2926dceda646bd8'

  depends_on 'qt'

  def install
    system "./configure", "-release", "-prefix", prefix
    system "make install"
  end
end
