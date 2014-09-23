require "formula"

class Periodic < Formula
  homepage "https://github.com/Lupino/periodic"
  url "https://github.com/Lupino/periodic/releases/download/0.1.2/periodic-osx", :tag => "v0.1.2"
  sha1 "9f155a79fcb8fa4715d303fd40e666a177de60a5"

  def install
    bin.install "periodic-osx" => "periodic"
  end

  test do
    system "#{bin}/periodic -h"
  end
end
