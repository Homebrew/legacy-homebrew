class Ansiweather < Formula
  desc "Weather in your terminal, with ANSI colors and Unicode symbols"
  homepage "https://github.com/fcambus/ansiweather"
  url "https://github.com/fcambus/ansiweather/archive/1.06.tar.gz"
  sha256 "1a2e09c648e0ca871b71146710020d8f86339e86ee6b1427bc1adb97740a2d0e"
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
