class Bmdtools < Formula
  desc "Basic capture and play programs for Blackmagic Design Decklink"
  homepage "https://github.com/lu-zero/bmdtools"
  url "https://github.com/lu-zero/bmdtools/archive/v0.1.tar.gz"
  sha256 "5576bb626fe7a69a54decb7eade7ab4254228cba333eebc292ffcbc492ef142f"
  head "https://github.com/lu-zero/bmdtools.git"

  depends_on "pkg-config" => :build
  depends_on "decklinksdk" => :build
  depends_on "ffmpeg"

  def install
    system "make", "SDK_PATH=#{Formula["decklinksdk"].opt_include}"
    bin.install "bmdcapture"
    bin.install "bmdgenlock"
    bin.install "bmdplay"
  end
end
