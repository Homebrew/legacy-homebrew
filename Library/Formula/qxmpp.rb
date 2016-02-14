class Qxmpp < Formula
  desc "Cross-platform C++ XMPP client and server library"
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v0.9.3.tar.gz"
  sha256 "13f5162a1df720702c6ae15a476a4cb8ea3e57d861a992c4de9147909765e6de"

  depends_on "qt"

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end
end
