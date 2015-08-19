class Icbirc < Formula
  desc "Proxy IRC client and ICB server"
  homepage "http://www.benzedrine.cx/icbirc.html"
  url "http://www.benzedrine.cx/icbirc-1.8.tar.gz"
  sha256 "ebc4c2482ac531149874ee77c188f6adcf509862ca2b600e9fe5057f555ecd92"

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end
