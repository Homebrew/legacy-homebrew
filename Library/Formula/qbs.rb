require "formula"

class Qbs < Formula
  homepage "http://qt-project.org/wiki/qbs"
  url "http://download.qt-project.org/official_releases/qbs/1.3.0/qbs-1.3.0.src.tar.gz"
  sha1 "27f2f0479fcb996e428bd4fa8379167e203d6d7a"

  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end
end
