require "formula"

class Icbirc < Formula
  homepage "http://www.benzedrine.cx/icbirc.html"
  url "http://www.benzedrine.cx/icbirc-1.8.tar.gz"
  sha1 "99ff8674b189fdf8a86b6acd2bc19418b888c38b"

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end
