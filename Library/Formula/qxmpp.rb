class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v0.8.0.tar.gz"
  sha256 "00aa821ab9e18d33ad15f12ae80aca8c3d9180e40d419ae34a90bfab91a78b02"

  depends_on "qt"

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end
end
