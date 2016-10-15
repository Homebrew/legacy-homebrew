require "formula"

class Osmtools < Formula
  homepage "https://wiki.openstreetmap.org/wiki/Osmconvert"
  url "https://github.com/vgrichina/osmtools/archive/1.0.tar.gz"
  sha1 "6ed392a2985e9e1816482e8b3d386bceeb3eb9d6"

  def install
    system "make", "all"
    bin.install "osmfilter", "osmconvert", "osmupdate"
  end

  test do
    system "#{bin}/osmfilter", "-h"
    system "#{bin}/osmconvert", "-h"
    system "#{bin}/osmupdate", "-h"
  end
end
