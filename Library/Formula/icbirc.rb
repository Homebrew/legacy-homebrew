class Icbirc < Formula
  desc "Proxy IRC client and ICB server"
  homepage "http://www.benzedrine.cx/icbirc.html"
  url "http://www.benzedrine.ch/icbirc-2.0.tar.gz"
  sha256 "7607c7d80fc3939ccb913c9fcc57a63d3552af3615454e406ff0e3737c0ce6bd"

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end
