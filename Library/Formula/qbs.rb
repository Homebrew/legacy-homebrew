require "formula"

class Qbs < Formula
  homepage "http://qt-project.org/wiki/qbs"
  url "http://download.qt-project.org/official_releases/qbs/1.2.0/qbs-1.2.0.src.tar.gz"
  sha1 "55c50218e03f4b2455e552942eca6293ba7d6cf6"
  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end
end
