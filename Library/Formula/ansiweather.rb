class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.04.tar.gz"
  sha256 "a85b0aba801f1fa3d386e92017c9b6af242b0243961a2a2f2e44096a8d7ddd75"
  head "https://github.com/fcambus/ansiweather.git"

  bottle :unneeded

  depends_on "jq"

  def install
    bin.install "ansiweather"
  end

  test do
    system bin/"ansiweather", "-h"
  end
end
