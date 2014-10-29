require "formula"

class Qbs < Formula
  homepage "http://qt-project.org/wiki/qbs"
  url "http://download.qt-project.org/official_releases/qbs/1.3.2/qbs-1.3.2.src.tar.gz"
  sha1 "ce2d807c145e239d39e360521d62486eb1e3d108"

  bottle do
    cellar :any
    sha1 "3aaeb476a15f023cebf99e87ef817fd0bfff6282" => :mavericks
    sha1 "9401c0d8025745fe1daefb691f49ee8c08cc347e" => :mountain_lion
    sha1 "7bec1a6ed1ff5d1798ccc1898110c38c94a68f5b" => :lion
  end

  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end
end
