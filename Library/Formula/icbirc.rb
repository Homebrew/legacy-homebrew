class Icbirc < Formula
  desc "Proxy IRC client and ICB server"
  homepage "http://www.benzedrine.ch/icbirc.html"
  url "http://www.benzedrine.ch/icbirc-2.0.tar.gz"
  sha256 "7607c7d80fc3939ccb913c9fcc57a63d3552af3615454e406ff0e3737c0ce6bd"

  bottle do
    cellar :any
    sha256 "08fa7b7435d429c8c21ff2d7835d0b7341fa3dd7cc5677241d1a897ec47cc883" => :yosemite
    sha256 "d16b5155b2f117cdc442eef09114ecffe180ecaf3c67e3c501374ba6e03a144a" => :mavericks
    sha256 "fec513444c71ecef76d4b5650749f2a18cbfb16dc6cf35894ddd46b0096c248b" => :mountain_lion
  end

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end
