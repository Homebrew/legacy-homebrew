class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.07.tar.gz"
  sha256 "f9b377b23ecc9c2d3567424b300b8e370eb0959c9b1cd0828ba07ce38f2ef0a0"
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
