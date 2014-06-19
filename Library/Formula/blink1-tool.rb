require "formula"

class Blink1Tool < Formula
  homepage "http://thingm.com/products/blink-1.html"
  url "https://github.com/todbot/blink1/archive/v1.81.tar.gz"
  sha1 "8fd96bfad3e6781b165848ef59723fd4ceb16bc4"

  def install
    cd "commandline" do
      system "make"
      bin.install "blink1-tool"
    end
  end

  test do
    system "#{bin}/blink1-tool", "--version"
  end
end
