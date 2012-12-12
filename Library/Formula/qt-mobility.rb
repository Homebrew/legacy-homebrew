require 'formula'

class QtMobility < Formula
  homepage 'http://qt.nokia.com/products/qt-addons/mobility'
  url 'git://gitorious.org/qt-mobility/qt-mobility.git', :revision => '1ccbeab'
  version '1.2.0-1ccbeab'

  depends_on 'qt'

  def patches
    # Fixes build on case sensitive filesystems
    'http://lists.qt.nokia.com/pipermail/qt-mobility-feedback/attachments/20120220/be90dd45/attachment.obj'
  end

  def install
    system "./configure", "-release", "-prefix", prefix, "-qmake-exec", "#{HOMEBREW_PREFIX}/bin/qmake"
    system "make install"

    # Move all .apps out of the "bin/" and into the prefix (like qt formula)
    Pathname.glob(bin + '*.app').each do |path|
      mv path, prefix
    end
  end
end
