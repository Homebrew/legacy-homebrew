require 'formula'

class QtMobility < Formula
  url 'http://get.qt.nokia.com/qt/add-ons/qt-mobility-opensource-src-1.1.1.tar.gz'
  homepage 'http://qt.nokia.com/'
  md5 'eb1e89b47b8ff2f831ba718938f7b959'

  depends_on 'qt'

  def install
    system "./configure", "-release", "-prefix", prefix
    system "make install"
  end
end
