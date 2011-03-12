require 'formula'

class QtMobility <Formula
  url 'http://get.qt.nokia.com/qt/add-ons/qt-mobility-opensource-src-1.1.0.tar.gz'
  homepage 'http://qt.nokia.com/'
  md5 '0bf8603493058735e16b35349da121df'

  depends_on 'qt'

  def install
    system "./configure", "-release", "-prefix", prefix
    system "make install"
  end
end
