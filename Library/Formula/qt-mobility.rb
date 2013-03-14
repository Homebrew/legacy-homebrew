require 'formula'

class QtMobility < Formula
  homepage 'http://qt.nokia.com/products/qt-addons/mobility'
  url 'git://gitorious.org/qt-mobility/qt-mobility.git', :revision => '6a75140'
  version '1.2.0-6a75140'

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
