require "formula"

class Qxmpp < Formula
  homepage "https://github.com/qxmpp-project/qxmpp/"
  url "https://github.com/qxmpp-project/qxmpp/archive/v0.8.0.tar.gz"
  sha1 "2b44f68e9e5ef127728819f051becbc207ad78e2"

  depends_on "qt"

  def install
    system "qmake", "-config", "release", "PREFIX=#{prefix}"
    system "make"
    system "make install"
  end
end
