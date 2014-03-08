require "formula"

class Qbs < Formula
  homepage "http://qt-project.org/wiki/qbs"
  url "git://gitorious.org/qt-labs/qbs.git", :tag => 'v1.1.2'
  depends_on 'qt5'

  def install
    system "pwd"
    system "qmake", "qbs.pro", "-r"
    system "make", "install", "INSTALL_ROOT=/usr/local"
  end

  test do
    system "#{bin}/qbs", "help"
  end
end
