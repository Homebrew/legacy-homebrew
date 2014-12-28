require "formula"

class Blink1 < Formula
  homepage "http://thingm.com/products/blink-1.html"
  url "https://github.com/todbot/blink1/archive/v1.95.tar.gz"
  sha1 "df305465360abe51de38684b82ea73c33a0fd2ae"
  head "https://github.com/todbot/blink1.git"

  bottle do
    cellar :any
    sha1 "1fff8150d6f2a9d558cc703c184b90caab5ec9a4" => :yosemite
    sha1 "478beff9bcd97cefdca3c5964f7bba7b9f37be09" => :mavericks
    sha1 "a4859412a9cd9f3377859713c6f59c148a66fc49" => :mountain_lion
  end

  def install
    cd "commandline" do
      system "make"
      bin.install "blink1-tool"
      lib.install "libBlink1.dylib"
      include.install "blink1-lib.h"
    end
  end

  test do
    system "#{bin}/blink1-tool", "--version"
  end
end
