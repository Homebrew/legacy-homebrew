require 'formula'

class QtMobility < Formula
  homepage 'http://qt.nokia.com/products/qt-addons/mobility'
  url 'git://gitorious.org/qt-mobility/qt-mobility.git', :revision => 'c1d67f4'
  version '1.2.0-c1d67f4'

  depends_on 'qt'

  def install
    system "./configure", "-release", "-prefix", prefix, "-qmake-exec", "#{HOMEBREW_PREFIX}/bin/qmake"
    system "make"
    ENV.j1
    system "make install"

    # Move all .apps out of the "bin/" and into the prefix (like qt formula)
    Pathname.glob(bin + '*.app').each do |path|
      mv path, prefix
    end
  end
end
