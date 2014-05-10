require "formula"

class Qbs < Formula
  homepage "http://qt-project.org/wiki/qbs"
  url "http://download.qt-project.org/official_releases/qbs/1.1.2/qbs-1.1.2.src.tar.gz"
  sha1 "0350f2947f461bda33ee7e296d838004036f1e8e"
  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end
end
