require "formula"

class Qbs < Formula
  homepage "http://qt-project.org/wiki/qbs"
  url "http://download.qt-project.org/official_releases/qbs/1.2.2/qbs-1.2.2.src.tar.gz"
  sha1 "15a9e16e17dbe9927c2e6464845a0819935050dc"

  bottle do
    cellar :any
    sha1 "45e34be2e5412f04d124ae3908462fec8cfa27f5" => :mavericks
    sha1 "f20faaed72c8347174756eeaea47139875116818" => :mountain_lion
    sha1 "43786e8f310f4c13743fff288e2ea31fcdcd5dfd" => :lion
  end

  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end
end
