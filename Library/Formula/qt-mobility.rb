require 'formula'

class QtMobility < Formula
  url 'http://get.qt.nokia.com/qt/add-ons/qt-mobility-opensource-src-1.1.1.tar.gz'
  homepage 'http://qt.nokia.com/'
  sha1 '8fba3540f09e56a9efd24c799fb1d07c9d953f2a'

  depends_on 'qt'

  def install
    system "./configure", "-release", "-prefix", prefix
    system "make install"
  end
end
