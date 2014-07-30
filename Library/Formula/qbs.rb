require "formula"

class Qbs < Formula
  homepage "http://qt-project.org/wiki/qbs"
  url "http://download.qt-project.org/official_releases/qbs/1.2.2/qbs-1.2.2.src.tar.gz"
  sha1 "15a9e16e17dbe9927c2e6464845a0819935050dc"
  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end
end
