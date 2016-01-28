class TarsnapGui < Formula
  desc "Cross platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki/Tarsnap"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v0.8.tar.gz"
  sha256 "a4b5b23b6b75aa7a4af4d124521286c80d42446571cb27a858d03e772b2ff080"
  head "https://github.com/Tarsnap/tarsnap-gui.git"

  depends_on "qt5"
  depends_on "tarsnap"

  def install
    system "qmake"
    system "make"
    prefix.install "Tarsnap.app"
  end

  test do
    system "#{opt_prefix}/Tarsnap.app/Contents/MacOS/Tarsnap", "--version"
  end
end
